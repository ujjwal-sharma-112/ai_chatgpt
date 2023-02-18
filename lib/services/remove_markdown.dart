String removeMarkdown(String markdown) {
  // Replace two or more newlines with plain text
  markdown = markdown.replaceAll(RegExp(r'\n{2,}'), '');

  return markdown;
}
