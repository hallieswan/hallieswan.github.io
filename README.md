# hallieswan.github.io

I've created this repo to host my personal website. I'm using a [R Markdown website](https://bookdown.org/yihui/rmarkdown/rmarkdown-site.html) hosted on [GitHub Pages](https://pages.github.com) to host the content. 

## Resources

- [Using RStudio to set up GitHub Pages](https://resources.github.com/github-and-rstudio/)
- [R Markdown Websites](https://bookdown.org/yihui/rmarkdown/rmarkdown-site.html)

## Set-up Notes

### Images

Occasionally, I include images in my pages. There are [several strategies](https://stackoverflow.com/questions/25166624/insert-picture-table-in-r-markdown) for including images in RMarkdown files. I could either store the images externally (e.g. public S3 bucket) or internally (e.g. in this repo). 

Currently, I'm storing the images directly in the repo. I initially created an `images` subdirectory in the root directory, then used `knitr::include_graphics` to include the image in the HTML output. However, `rmarkdown::render_site` copies all supporting files into the site directory (`docs`), so I ended up with duplicated copies of each image. 

I want to avoid storing duplicated copies of images, so I moved the images into an `images` subdirectory in the `docs`directory. Then, when the site is rendered, the images will be available. However, when the site is built via `rmarkdown::render_site`, I understandably got an error that knitr couldn't find the image files, because they no longer exist at the path relative to the Rmd file. However, `knitr::include_graphics` can be set to ignore errors where the file does not exist, so that the site can still be rendered. When the site is displayed, the images are available via the path relative to the HTML files in the `docs` directory, so the images appear correctly. 

Short-term, this will allow me to both make the images available for my site and avoid duplicating the image files. Long-term, I may consider storing the images externally instead.
