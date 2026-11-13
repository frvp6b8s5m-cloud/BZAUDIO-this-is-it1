from html.parser import HTMLParser
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[1]


class SiteParser(HTMLParser):
    def __init__(self):
        super().__init__()
        self.ids = []
        self.links = []
        self.headings = []
        self.landmarks = set()

    def handle_starttag(self, tag, attrs):
        attributes = dict(attrs)
        if "id" in attributes:
            self.ids.append(attributes["id"])
        if tag == "a" and attributes.get("href", "").startswith("#"):
            self.links.append(attributes["href"][1:])
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

    def test_external_font_is_not_required_for_fallback(self):
        self.assertIn("'Helvetica Neue', sans-serif", self.css)
        self.assertIn("'Courier New', monospace", self.css)


if __name__ == "__main__":
    unittest.main()