# parallax-hero
A Parallax Hero Image creates a depth and transition effect when scrolling down to the main hero of your page to the content below. In the following tutorial, [Solodev](https://www.solodev.com/) shows you how to add a parallax hero image to your website.

## Tutorial

View detailed instructionss in Solodev's [How to Create a Parallax Hero Image](https://www.solodev.com/blog/web-design/how-to-create-a-parallax-hero-image.stml) article.

## Demo

Try out a working example on [JSFiddle](https://jsfiddle.net/solodev/ropp9gv3/).

## HTML

The parallax hero image contains the following basic HTML markup.
```
<section class="hero">
   <h1>Parallax Hero Image</h1>
</section>
<section class="content">
   <section class="ct_icon_box_section">
      <div class="container">
         <div class="ct-section_header ct-section_header--type2">
            <h2>
               A World-Class Approach to Business
            </h2>
            <div class="ct-section_header-description">
               Companies are looking to do business with other great companies. WebCorpCo theme has what it takes to show the world you mean business.
            </div>
            <div class="clearfix">
               &nbsp;
            </div>
            <div class="ct-section_header-separator">
               &nbsp;
            </div>
         </div>
         <div class="row">
            <div class="col-md-4 col-sm-6">
               <div class="ct-icon_box media" onclick="location.href='#'">
                  <div class="media-left">
                     <i class="fa fa-users"></i>
                  </div>
                  <div class="media-body">
                     <h3 class="media-heading">
                        Marketing
                     </h3>
                     <div class="ct-icon_box-content">
                        Market to the right person, at the right time, at the place.
                     </div>
                  </div>
               </div>
            </div>
            <div class="col-md-4 col-sm-6">
               <div class="ct-icon_box media" onclick="location.href='#'">
                  <div class="media-left">
                     <i class="fa fa-cogs"></i>
                  </div>
                  <div class="media-body">
                     <h3 class="media-heading">
                        Sales
                     </h3>
                     <div class="ct-icon_box-content">
                        Improve sales through the use of Big Data and Analytics.
                     </div>
                  </div>
               </div>
            </div>
            <div class="col-md-4 col-sm-6">
               <div class="ct-icon_box media" onclick="location.href='#'">
                  <div class="media-left">
                     <i class="fa fa-clipboard"></i>
                  </div>
                  <div class="media-body">
                     <h3 class="media-heading">
                        Design
                     </h3>
                     <div class="ct-icon_box-content">
                        Benefit from award winning mobile responsive design.
                     </div>
                  </div>
               </div>
            </div>
            <div class="col-md-4 col-sm-6">
               <div class="ct-icon_box media" onclick="location.href='#'">
                  <div class="media-left">
                     <i class="fa fa-globe"></i>
                  </div>
                  <div class="media-body">
                     <h3 class="media-heading">
                        Programming
                     </h3>
                     <div class="ct-icon_box-content">
                        No need to program. WebCorpCo does all of the coding for you.
                     </div>
                  </div>
               </div>
            </div>
            <div class="col-md-4 col-sm-6">
               <div class="ct-icon_box media" onclick="location.href='#'">
                  <div class="media-left">
                     <i class="fa fa-user-plus"></i>
                  </div>
                  <div class="media-body">
                     <h3 class="media-heading">
                        Support
                     </h3>
                     <div class="ct-icon_box-content">
                        We offer 24/7 365 global support for all enterprise customers.&nbsp;
                     </div>
                  </div>
               </div>
            </div>
            <div class="col-md-4 col-sm-6">
               <div class="ct-icon_box media" onclick="location.href='#'">
                  <div class="media-left">
                     <i class="fa fa-line-chart"></i>
                  </div>
                  <div class="media-body">
                     <h3 class="media-heading">
                        Training
                     </h3>
                     <div class="ct-icon_box-content">
                        Benefit from webinars and training sessions offered regularly.
                     </div>
                  </div>
               </div>
            </div>
         </div>
         <div class="row">
            <div class="col-md-4 col-sm-6">
               <div class="ct-icon_box media" onclick="location.href='#'">
                  <div class="media-left">
                     <i class="fa fa-users"></i>
                  </div>
                  <div class="media-body">
                     <h3 class="media-heading">
                        Marketing
                     </h3>
                     <div class="ct-icon_box-content">
                        Market to the right person, at the right time, at the place.
                     </div>
                  </div>
               </div>
            </div>
            <div class="col-md-4 col-sm-6">
               <div class="ct-icon_box media" onclick="location.href='#'">
                  <div class="media-left">
                     <i class="fa fa-cogs"></i>
                  </div>
                  <div class="media-body">
                     <h3 class="media-heading">
                        Sales
                     </h3>
                     <div class="ct-icon_box-content">
                        Improve sales through the use of Big Data and Analytics.
                     </div>
                  </div>
               </div>
            </div>
            <div class="col-md-4 col-sm-6">
               <div class="ct-icon_box media" onclick="location.href='#'">
                  <div class="media-left">
                     <i class="fa fa-clipboard"></i>
                  </div>
                  <div class="media-body">
                     <h3 class="media-heading">
                        Design
                     </h3>
                     <div class="ct-icon_box-content">
                        Benefit from award winning mobile responsive design.
                     </div>
                  </div>
               </div>
            </div>
            <div class="col-md-4 col-sm-6">
               <div class="ct-icon_box media" onclick="location.href='#'">
                  <div class="media-left">
                     <i class="fa fa-globe"></i>
                  </div>
                  <div class="media-body">
                     <h3 class="media-heading">
                        Programming
                     </h3>
                     <div class="ct-icon_box-content">
                        No need to program. WebCorpCo does all of the coding for you.
                     </div>
                  </div>
               </div>
            </div>
            <div class="col-md-4 col-sm-6">
               <div class="ct-icon_box media" onclick="location.href='#'">
                  <div class="media-left">
                     <i class="fa fa-user-plus"></i>
                  </div>
                  <div class="media-body">
                     <h3 class="media-heading">
                        Support
                     </h3>
                     <div class="ct-icon_box-content">
                        We offer 24/7 365 global support for all enterprise customers.&nbsp;
                     </div>
                  </div>
               </div>
            </div>
            <div class="col-md-4 col-sm-6">
               <div class="ct-icon_box media" onclick="location.href='#'">
                  <div class="media-left">
                     <i class="fa fa-line-chart"></i>
                  </div>
                  <div class="media-body">
                     <h3 class="media-heading">
                        Training
                     </h3>
                     <div class="ct-icon_box-content">
                        Benefit from webinars and training sessions offered regularly.
                     </div>
                  </div>
               </div>
            </div>
         </div>
      </div>
   </section>
</section>

```
## CSS

All required CSS is in hero.css

## External Includes

The following thirty party plugins are included.
```
<link href="https://fonts.googleapis.com/css?family=Roboto+Condensed" rel="stylesheet">
<link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.3/css/font-awesome.min.css">
<link rel="stylesheet" href="parallax-hero.css">

<script src="https://code.jquery.com/jquery-2.2.0.min.js" type="text/javascript"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
```
