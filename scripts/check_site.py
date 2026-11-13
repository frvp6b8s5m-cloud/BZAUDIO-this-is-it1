#!/usr/bin/env python3
"""Dependency-free structural checks for every public BZaudio HTML page."""

from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import urlsplit
import sys

ROOT = Path(__file__).resolve().parents[1]


class SiteParser(HTMLParser):
    def __init__(self):
        super().__init__()
        self.ids = set()
        self.links = []
        self.images = []
        self.buttons = []
        self.h1_count = 0
        self.has_main = False
        self.has_header = False
        self.has_footer = False
        self.in_title = False
        self.title_text = False
        self.description = False
        self.has_current_page = False

    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        if tag == "title":
            self.in_title = True
        if tag == "h1":
            self.h1_count += 1
        if tag == "main":
            self.has_main = True
        if tag == "header":
            self.has_header = True
        if tag == "footer":
            self.has_footer = True
        if attrs.get("id"):
            if attrs["id"] in self.ids:
                self.ids.add(f"__duplicate__{attrs['id']}")
            self.ids.add(attrs["id"])
        if tag == "a":
            self.links.append(attrs.get("href", ""))
            if attrs.get("aria-current") == "page":
                self.has_current_page = True
        if tag == "img":
            self.images.append(attrs)
        if tag == "button":
            self.buttons.append(attrs)
        if tag == "meta" and attrs.get("name") == "description":
            self.description = bool(attrs.get("content", "").strip())

    def handle_endtag(self, tag):
        if tag == "title":
            self.in_title = False

    def handle_data(self, data):
        if self.in_title and data.strip():
            self.title_text = True


def main():
    errors = []
    html_files = sorted(ROOT.glob("*.html"))
    css_path = ROOT / "styles.css"
    js_path = ROOT / "script.js"

    if not html_files:
        errors.append("No public HTML pages were found.")
    for path in (css_path, js_path):
        if not path.is_file():
            errors.append(f"Missing required file: {path.relative_to(ROOT)}")
    if errors:
        return errors

    css = css_path.read_text(encoding="utf-8")
    js = js_path.read_text(encoding="utf-8")

    if css.count("{") != css.count("}"):
        errors.append("CSS braces must be balanced.")
    if "prefers-reduced-motion" not in css:
        errors.append("CSS must respect prefers-reduced-motion.")
    if "aria-expanded" not in js:
        errors.append("JavaScript must update aria-expanded for the mobile menu.")

    for path in html_files:
        html = path.read_text(encoding="utf-8")
        parser = SiteParser()
        parser.feed(html)
        page = path.name

        if not parser.title_text:
            errors.append(f"{page}: missing a non-empty title.")
        if not parser.description:
            errors.append(f"{page}: missing a meta description.")
        if parser.h1_count != 1:
            errors.append(f"{page}: expected exactly one h1; found {parser.h1_count}.")
        if not parser.has_header or not parser.has_main or not parser.has_footer:
            errors.append(f"{page}: use semantic header, main, and footer landmarks.")
        if not parser.has_current_page:
            errors.append(f"{page}: mark the current navigation link with aria-current='page'.")
        if any("alt" not in image for image in parser.images):
            errors.append(f"{page}: every image must include an alt attribute.")
        for button in parser.buttons:
            if not button.get("type"):
                errors.append(f"{page}: every button must declare its type.")
            if not (button.get("aria-label") or button.get("title")):
                errors.append(f"{page}: every icon-only button must have an accessible name.")
        if "__duplicate__" in " ".join(parser.ids):
            errors.append(f"{page}: duplicate element IDs were found.")
        for link in parser.links:
            if link.startswith("#") and link[1:] not in parser.ids:
                errors.append(f"{page}: broken in-page link {link}.")
            parts = urlsplit(link)
            if link and not parts.scheme and not link.startswith("#"):
                local_path = (ROOT / parts.path).resolve()
                if not local_path.is_file():
                    errors.append(f"{page}: broken local link {link}.")
        lowered = html.lower()
        if 'href="tel:' in lowered or "href='tel:" in lowered:
            errors.append(f"{page}: the approved site must not publish a phone number.")
        if page == "contact.html":
            if 'href="mailto:benrz101@gmail.com"' not in lowered:
                errors.append(f"{page}: the approved contact email must be published.")
        elif 'href="mailto:' in lowered or "href='mailto:" in lowered:
            errors.append(f"{page}: publish email contact only on the Contact page.")
        if "<script" not in lowered or "defer" not in lowered:
            errors.append(f"{page}: load the site script with defer.")
        if 'id="primary-navigation"' not in lowered or 'aria-controls="primary-navigation"' not in lowered:
            errors.append(f"{page}: mobile navigation button must be associated with its navigation.")

    return errors


if __name__ == "__main__":
    failures = main()
    if failures:
        for failure in failures:
            print(f"FAIL: {failure}")
        sys.exit(1)
    print("PASS: all BZaudio pages pass structural, navigation, and accessibility guardrails.")
