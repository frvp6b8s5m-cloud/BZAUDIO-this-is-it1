#!/usr/bin/env python3
"""Dependency-free structural checks for the BZaudio static website."""

from html.parser import HTMLParser
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]


class SiteParser(HTMLParser):
    def __init__(self):
        super().__init__()
        self.tags = []
        self.ids = set()
        self.links = []
        self.images = []
        self.buttons = []
        self.h1_count = 0
        self.has_main = False
        self.has_header = False
        self.has_footer = False
        self.title_text = False
        self.description = False

    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        self.tags.append(tag)
        if tag == "h1":
            self.h1_count += 1
        if tag == "main":
            self.has_main = True
        if tag == "header":
            self.has_header = True
        if tag == "footer":
            self.has_footer = True
        if attrs.get("id"):
            self.ids.add(attrs["id"])
        if tag == "a":
            self.links.append(attrs.get("href", ""))
        if tag == "img":
            self.images.append(attrs)
        if tag == "button":
            self.buttons.append(attrs)
        if tag == "meta" and attrs.get("name") == "description":
            self.description = bool(attrs.get("content", "").strip())

    def handle_data(self, data):
        if "title" in self.tags and data.strip():
            self.title_text = True


def main():
    errors = []
    html_path = ROOT / "index.html"
    css_path = ROOT / "styles.css"
    js_path = ROOT / "script.js"

    for path in (html_path, css_path, js_path):
        if not path.is_file():
            errors.append(f"Missing required file: {path.relative_to(ROOT)}")

    if errors:
        return errors

    html = html_path.read_text(encoding="utf-8")
    css = css_path.read_text(encoding="utf-8")
    js = js_path.read_text(encoding="utf-8")
    parser = SiteParser()
    parser.feed(html)

    if not parser.title_text:
        errors.append("The page must have a non-empty title.")
    if not parser.description:
        errors.append("The page must have a meta description.")
    if parser.h1_count != 1:
        errors.append(f"Expected exactly one h1; found {parser.h1_count}.")
    if not parser.has_header or not parser.has_main or not parser.has_footer:
        errors.append("Use semantic header, main, and footer landmarks.")
    if any("alt" not in image for image in parser.images):
        errors.append("Every image must have meaningful alt text or an explicit empty alt.")
    for button in parser.buttons:
        if not button.get("type"):
            errors.append("Every button must declare its type.")
        if not (button.get("aria-label") or button.get("title")):
            errors.append("Every icon-only button must have an accessible name.")
    for link in parser.links:
        if link.startswith("#") and link[1:] not in parser.ids:
            errors.append(f"Broken in-page link: {link}")
    if 'href="tel:' in html.lower() or "href='tel:" in html.lower():
        errors.append("The approved website must not publish a phone number.")
    if 'href="mailto:' in html.lower() or "href='mailto:" in html.lower():
        errors.append("Email contact must remain unconfigured until the owner supplies it.")
    if css.count("{") != css.count("}"):
        errors.append("CSS braces must be balanced.")
    if "prefers-reduced-motion" not in css:
        errors.append("CSS must respect prefers-reduced-motion.")
    if "aria-expanded" not in html or "aria-expanded" not in js:
        errors.append("The mobile navigation toggle must expose and update aria-expanded.")
    if "<script" not in html or "defer" not in html:
        errors.append("Load the site script with defer.")

    return errors


if __name__ == "__main__":
    failures = main()
    if failures:
        for failure in failures:
            print(f"FAIL: {failure}")
        sys.exit(1)
    print("PASS: BZaudio static site structure and accessibility guardrails.")
