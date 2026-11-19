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
        self.assertIn("prefers-reduced-motion:reduce", self.css)
        self.assertIn("prefers-reduced-motion: reduce", self.js)
        self.assertIn("@keyframes orbit-turn", self.css)

    def test_light_section_uses_contrast_safe_small_text_colors(self):
        self.assertIn(".section-label{", self.css)
        self.assertIn("--paper:#f5f3ee;", self.css)

    def test_responsive_breakpoints_are_defined(self):
        self.assertIn("@media(max-width:980px)", self.css)
        self.assertIn("@media(max-width:680px)", self.css)

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
            "index.html", "products.html", "solutions.html", "about.html", "contact.html", "request.html", "origin.html"
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

    def test_every_page_uses_the_same_core_navigation(self):
        expected = {"index.html", "products.html", "solutions.html", "about.html", "contact.html", "request.html", "origin.html"}
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
        self.assertIn("'Helvetica Neue',sans-serif", self.css)
        self.assertIn("'Courier New',monospace", self.css)


    def test_architectural_motion_language_is_present(self):
        self.assertIn(".hero-logo-stage", self.css)
        self.assertIn("border-radius:50%", self.css)
        self.assertIn("prefers-reduced-motion:reduce", self.css)

    def test_external_link_arrows_are_replaced_with_plus_marks(self):
        for page_path in ROOT.glob("*.html"):
            with self.subTest(page=page_path.name):
                html = page_path.read_text(encoding="utf-8")
                self.assertNotIn("↗", html)
        self.assertIn("principle-mark", self.html)


    def test_official_brand_logo_is_used_in_every_page_header_and_footer(self):
        for page_name in ["index.html", "products.html", "solutions.html", "about.html", "contact.html", "request.html", "origin.html"]:
            with self.subTest(page=page_name):
                html = (ROOT / page_name).read_text(encoding="utf-8")
                self.assertIn('src="assets/bzaudio-logo.png"', html)
                self.assertIn('alt="BZaudio"', html)
                if page_name != "origin.html":
                    self.assertIn('class="footer-wordmark"', html)
                else:
                    self.assertIn('class="origin-footer"', html)
                self.assertNotIn('class="wordmark-symbol"', html)

    def test_homepage_uses_the_new_brand_hero_copy(self):
        self.assertIn("Music", self.html)
        self.assertIn("brings", self.html)
        self.assertIn("life.", self.html)
        self.assertIn("CREATIVE SOUNDS / EST. 2025", self.html)
        self.assertIn('class="hero-logo-stage"', self.html)

    def test_origin_gateway_is_minimal_and_does_not_fake_authentication(self):
        html = (ROOT / "origin.html").read_text(encoding="utf-8")
        parser = SiteParser()
        parser.feed(html)
        self.assertEqual(parser.headings.count("h1"), 1)
        self.assertIn(">ORIGIN</h1>", html)
        self.assertIn("LOGIN", html)
        self.assertIn('aria-disabled="true"', html)
        self.assertIn("MEMBER ACCESS IS NOT ACTIVE YET", html)
        self.assertNotIn("<input", html.lower())
        self.assertNotIn("password", html.lower())
        self.assertNotIn("supabase", html.lower())

    def test_equipment_request_is_an_honest_email_inquiry(self):
        html = (ROOT / "request.html").read_text(encoding="utf-8")
        self.assertIn('id="equipment-request-form"', html)
        self.assertIn('name="customer-name"', html)
        self.assertIn('name="customer-email"', html)
        self.assertIn('id="add-request-item"', html)
        self.assertIn("This is an inquiry, not an order.", html)
        self.assertIn("You must send the email yourself.", html)
        self.assertIn("NO CHECKOUT / NO PAYMENT / NO AUTOMATIC ORDER", html)
        js = (ROOT / "script.js").read_text(encoding="utf-8")
        self.assertIn("mailto:benrz101@gmail.com", js)
        self.assertIn("encodeURIComponent(body)", js)

    def test_product_categories_open_prefilled_request_flow(self):
        html = (ROOT / "products.html").read_text(encoding="utf-8")
        for category in ["mixing-consoles", "speakers-subwoofers", "microphones", "wireless-systems",
                         "headphones", "processors-effects", "amplifiers", "cables-accessories"]:
            with self.subTest(category=category):
                self.assertIn("request.html?category=" + category, html)

    def test_manufacturer_directory_has_source_links_and_request_prefill(self):
        html = (ROOT / "products.html").read_text(encoding="utf-8")
        for name in ["dLive", "Avantis", "SQ / SQ+", "Qu", "CQ", "RIVAGE PM", "DM7", "DM5",
                     "DM3", "MGX Digital Mixer", "TF", "TF-RACK", "SM58", "SM57", "BETA 58A",
                     "SM7B", "Nexadyne 8", "KSM8", "KSM9"]:
            with self.subTest(product=name):
                self.assertIn(name, html)
        self.assertIn("https://www.allen-heath.com/hardware/", html)
        self.assertIn("https://usa.yamaha.com/business/audio/products/mixers/", html)
        self.assertIn("https://www.shure.com/en-US/products/microphones", html)
        self.assertIn("request.html?manufacturer=", html)
        self.assertIn("Individual SKU, regional variant", html)

    def test_logo_asset_is_intact_and_all_presentations_preserve_its_aspect_ratio(self):
        logo = ROOT / "assets" / "bzaudio-logo.png"
        self.assertTrue(logo.is_file())
        data = logo.read_bytes()
        self.assertEqual(data[:8], bytes([137, 80, 78, 71, 13, 10, 26, 10]))
        width = int.from_bytes(data[16:20], "big")
        height = int.from_bytes(data[20:24], "big")
        self.assertGreater(width, 0)
        self.assertGreater(height, 0)
        self.assertGreater(width / height, 1.5, "The official horizontal wordmark should retain its landscape aspect ratio")
        self.assertIn("object-fit:contain", self.css)
        self.assertIn(".wordmark img", self.css)
        self.assertIn(".footer-wordmark img", self.css)
        self.assertIn(".hero-logo-stage img", self.css)
        for page_path in ROOT.glob("*.html"):
            with self.subTest(page=page_path.name):
                html = page_path.read_text(encoding="utf-8")
                self.assertIn('src="assets/bzaudio-logo.png"', html)


if __name__ == "__main__":
    unittest.main()
