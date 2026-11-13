from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import urlsplit
import unittest

ROOT = Path(__file__).resolve().parents[1]


class SiteParser(HTMLParser):
    def __init__(self):
        super().__init__()
        self.ids = []
        self.links = []
        self.all_links = []
        self.headings = []
        self.landmarks = set()

    def handle_starttag(self, tag, attrs):
        attributes = dict(attrs)
        if "id" in attributes:
            self.ids.append(attributes["id"])
        if tag == "a":
            href = attributes.get("href", "")
            self.all_links.append(href)
            if href.startswith("#"):
                self.links.append(href[1:])
        if tag in {"header", "nav", "main", "footer"}:
            self.landmarks.add(tag)
        if tag in {"h1", "h2", "h3"}:
            self.headings.append(tag)


class WebsiteFoundationTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.html = (ROOT / "index.html").read_text(encoding="utf-8")
        cls.css = (ROOT / "styles.css").read_text(encoding="utf-8")
        cls.js = (ROOT / "script.js").read_text(encoding="utf-8")
        cls.parser = SiteParser()
        cls.parser.feed(cls.html)

    def test_document_has_language_and_title(self):
        self.assertRegex(self.html, r'<html lang="en">')
        self.assertRegex(self.html, r"<title>[^<]+</title>")
        self.assertIn('name="viewport"', self.html)

    def test_one_primary_heading(self):
        self.assertEqual(self.parser.headings.count("h1"), 1)
        self.assertIn("MUSIC", self.html)
        self.assertIn("BRINGS", self.html)

    def test_semantic_landmarks_exist(self):
        self.assertTrue({"header", "nav", "main", "footer"}.issubset(self.parser.landmarks))
        self.assertIn('href="#main"', self.html)

    def test_internal_navigation_targets_exist(self):
        self.assertEqual(len(self.parser.ids), len(set(self.parser.ids)), "IDs must be unique")
        missing = sorted(set(self.parser.links) - set(self.parser.ids))
        self.assertEqual(missing, [], f"Broken in-page links: {missing}")

    def test_local_assets_are_linked(self):
        self.assertTrue((ROOT / "styles.css").is_file())
        self.assertTrue((ROOT / "script.js").is_file())
        self.assertIn('href="styles.css"', self.html)
        self.assertIn('src="script.js"', self.html)

    def test_reduced_motion_is_supported(self):
        self.assertIn("prefers-reduced-motion: reduce", self.css)
        self.assertIn("prefers-reduced-motion: reduce", self.js)
        self.assertIn("@keyframes object-float", self.css)
        self.assertIn("@keyframes orbit-turn", self.css)

    def test_light_section_uses_contrast_safe_small_text_colors(self):
        self.assertIn(".intro .section-label { color: #62625b; }", self.css)
        self.assertIn(".intro .section-label span:first-child, .intro .eyebrow { color: #79542f; }", self.css)

    def test_responsive_breakpoints_are_defined(self):
        self.assertIn("@media (max-width: 980px)", self.css)
        self.assertIn("@media (max-width: 680px)", self.css)

    def test_mobile_navigation_is_accessible(self):
        self.assertIn('aria-expanded="false"', self.html)
        self.assertIn('aria-controls="primary-navigation"', self.html)
        self.assertIn("setAttribute('aria-expanded'", self.js)
        self.assertIn("navigation.classList.remove('is-open')", self.js)
        self.assertIn("event.key === 'Escape'", self.js)

    def test_no_placeholder_contact_or_phone_number(self):
        self.assertNotRegex(self.html, r"mailto:")
        self.assertNotRegex(self.html, r"tel:")

    def test_no_fake_product_claims_or_testimonials(self):
        self.assertNotRegex(self.html.lower(), r"\b(5\.0 out of 5|customer reviews|in stock|buy now)\b")


    def test_all_approved_pages_exist_and_have_one_clear_heading(self):
        expected_pages = {
            "index.html", "products.html", "solutions.html", "about.html", "contact.html"
        }
        self.assertTrue(expected_pages.issubset({path.name for path in ROOT.glob("*.html")}))
        for page_name in expected_pages:
            with self.subTest(page=page_name):
                html = (ROOT / page_name).read_text(encoding="utf-8")
                parser = SiteParser()
                parser.feed(html)
                self.assertRegex(html, r"<title>[^<]+</title>")
                self.assertRegex(html, r'<meta name="description" content="[^"]+">')
                self.assertEqual(parser.headings.count("h1"), 1)
                self.assertTrue({"header", "nav", "main", "footer"}.issubset(parser.landmarks))
                self.assertIn('href="styles.css"', html)
                self.assertIn('src="script.js"', html)

    def test_every_page_uses_the_same_five_page_navigation(self):
        expected = {"index.html", "products.html", "solutions.html", "about.html", "contact.html"}
        for page_name in expected:
            with self.subTest(page=page_name):
                parser = SiteParser()
                parser.feed((ROOT / page_name).read_text(encoding="utf-8"))
                self.assertTrue(expected.issubset(set(parser.all_links)))
                self.assertEqual(sum('aria-current="page"' in line for line in
                                     (ROOT / page_name).read_text(encoding="utf-8").splitlines()), 1)


    def test_all_pages_have_valid_local_links_and_fragment_targets(self):
        for page_path in ROOT.glob("*.html"):
            with self.subTest(page=page_path.name):
                html = page_path.read_text(encoding="utf-8")
                parser = SiteParser()
                parser.feed(html)
                for href in parser.all_links:
                    if not href or href.startswith(("http://", "https://", "mailto:", "tel:")):
                        continue
                    parts = urlsplit(href)
                    if parts.fragment:
                        self.assertIn(parts.fragment, parser.ids, f"{page_path.name}: broken fragment {href}")
                    if parts.path:
                        self.assertTrue((ROOT / parts.path).is_file(), f"{page_path.name}: broken local link {href}")

    def test_contact_page_uses_owner_supplied_email_only(self):
        for path in ROOT.glob("*.html"):
            with self.subTest(page=path.name):
                html = path.read_text(encoding="utf-8").lower()
                self.assertNotIn("tel:", html)
                if path.name == "contact.html":
                    self.assertIn('href="mailto:benrz101@gmail.com?subject=bzaudio%20inquiry"', html)
                else:
                    self.assertNotIn("mailto:", html)

    def test_external_font_is_not_required_for_fallback(self):
        self.assertIn("'Helvetica Neue', sans-serif", self.css)
        self.assertIn("'Courier New', monospace", self.css)


    def test_architectural_motion_language_is_present(self):
        self.assertIn(".hero-architecture-grid", self.css)
        self.assertIn("@keyframes architectural-drift", self.css)
        self.assertIn("@keyframes structural-draw", self.css)
        self.assertIn("clip-path", self.css)

    def test_external_link_arrows_are_replaced_with_plus_marks(self):
        for page_path in ROOT.glob("*.html"):
            with self.subTest(page=page_path.name):
                html = page_path.read_text(encoding="utf-8")
                self.assertNotIn("↗", html)
        self.assertIn("principle-mark", self.html)


if __name__ == "__main__":
    unittest.main()