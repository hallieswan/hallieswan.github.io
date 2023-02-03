# hallieswan.github.io

I've created this repo to host my personal website. I'm using a [R Markdown website](https://bookdown.org/yihui/rmarkdown/rmarkdown-site.html) hosted on [GitHub Pages](https://pages.github.com) to host the content. 

## Resources

- [Using RStudio to set up GitHub Pages](https://resources.github.com/github-and-rstudio/)
- [R Markdown Websites](https://bookdown.org/yihui/rmarkdown/rmarkdown-site.html)

## Repo Structure

Key files / directories in the repo are listed below, where "package" refers to the helper package that helps manage the build workflow, site refers to the Rmarkdown website, and post refers to a particular entry on the Rmarkdown website --

```
.
├── DESCRIPTION - package description file
├── NAMESPACE - package namespace file
├── R - package functions
├── README.md
├── _data - local data
├── _data_prep - scripts for pulling and storing data in _data
├── _site.yml - configuration file for site
├── docs - site content
├── index.Rmd - site homepage
├── man - man files for package
├── post-appalachian_trail_blog.Rmd - post file
└── post-nwc_wsoc_rankings.Rmd - post file
```

Since all posts are stored in the root directory, I'm using a `post-{post_name}.Rmd` naming convention to keep things a bit more organized. Long-term, I could consider switching to [blogdown](https://bookdown.org/yihui/blogdown/), which creates more full-featured Rmarkdown websites. 

## Set-up Notes

### Publishing Workflow

By default, `rmarkdown::render_site` renders all Rmd files in the root directory. However, I generally only want to re-render new articles and the index page, rather than all articles. I've created a [build_site function](R/build_site.R) to make it easier to render the site. So, now my workflow for re-rendering the site is: 

```r
devtools::load_all(".")
build_site()
```

Once I'm done working on a particular article, I'll add it to the list of Rmds to ignore in build_site, then reload the package.

### Images

Occasionally, I include images in my pages. There are [several strategies](https://stackoverflow.com/questions/25166624/insert-picture-table-in-r-markdown) for including images in RMarkdown files. I could either store the images externally (e.g. public S3 bucket) or internally (e.g. in this repo). 

Currently, I'm storing the images directly in the repo. I initially created an `images` subdirectory in the root directory, then used `knitr::include_graphics` to include the image in the HTML output. However, `rmarkdown::render_site` copies all supporting files into the site directory (`docs`), so I ended up with duplicated copies of each image. 

I want to avoid storing duplicated copies of images, so I moved the images into an `images` subdirectory in the `docs`directory. Then, when the site is rendered, the images will be available. However, when the site is built via `rmarkdown::render_site`, I understandably got an error that knitr couldn't find the image files, because they no longer exist at the path relative to the Rmd file. However, `knitr::include_graphics` can be set to ignore errors where the file does not exist, so that the site can still be rendered. When the site is displayed, the images are available via the path relative to the HTML files in the `docs` directory, so the images appear correctly. 

Short-term, this will allow me to both make the images available for my site and avoid duplicating the image files. Long-term, I may consider storing the images externally instead.
