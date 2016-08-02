# ADOP Documentation

This directory captures the ADOP documentation that is published to GitHub Pages. It will be periodically published alongside new releases by copying the contents of this folder into the gh-pages branch.

For more information on GitHub Pages:

- https://pages.github.com/
- https://help.github.com/categories/customizing-github-pages/

## Developing the Site

1. Make your desired changes in this directory
1. Test that they work locally by generating the site:
 - You can publish them to your own gh-pages branch (see instructions below too): https://help.github.com/articles/creating-project-pages-manually/
 - You can use Docker: docker-compose build && docker-compose up -d
 - You can generate the site locally by installing Jekyll: https://help.github.com/articles/setting-up-your-github-pages-site-locally-with-jekyll/
1. Submit a PR for the master branch
1. Make sure Travis is happy

## Publishing the Site

1. Checkout the "gh-pages" branch
1. Remove the contents with "git rm -r \*"
1. Checkout the site directory from the master branch with "git checkout master -- site"
1. Move the content out of the site directory with "git mv -f site/* site/.gitignore site/.travis.yml ."
1. Check that the changes are just what is expected with "git status"
1. Once satisfied, commit and push directly to origin 
1. Verify that GitHub Pages is reflecting the new changes (this can take a few minutes)
