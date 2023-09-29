# Regarding this addon's Markdown implementation

- Please refer to Github's [Basic writing and formatting syntax](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax).

## Supports

1. Headings  

2. Styling text, **except**:
	- Subscript
	- Superscript  
  
3. Quoting text - one level only and doesn't support nesting quotes  

4. Quoting code  

5. Quoting code blocks
	- No specification of language needed because GDScript's syntax highlighting is automatically applied.  
```
# YES
# ```
# var test: int = 0
# ```

# NO
# ```gdscript
# var test: int = 0
# ```
```
	
6. Links  

7. Images  

8. New-line
	- To add a new-line, end the previous line with two spaces.


## Limits - Doesn't support at the moment

1. Every HTML tag  

2. Supported color models  

3. Section links  

4. Relative links (might or might not work)  

5. **Lists** - difficult because Markdown's and BBCode's implementation of lists are quite different  

6. Tasks lists  

7. Mentioning people and teams  

8. Referencing issues and pull requests  

9. Referencing external resources  

10. Uploading assets  

11. Using emoji  

12. Paragraphs  

13. Footnotes  

14. Alerts  

15. Hiding content with comments  

16. Ignore Markdown formatting  

17. Disable Markdown rendering  

