{include resources/header.md}

<div class="contents">
<div class="system-links">

  * [Getting it][4]
  * [Documentation][5]
  * [News][6]
  * [Changelog][7]

</div>
<div class="system-description">

### What it is

CLNUPlot lets you manipulate plots in Lisp and then write out a command file that can executed in [GNUPlot][]. The basic model is one of plots and data-sets. A plot contains information for the entire information display; for example, the title, the axis labels and so forth. Each data set contains information about how to display a single group of data in some format; e.g., the data, the display style, the name of the data in the legend and so forth. A plot contains one or data sets. For example, this

    (clnuplot:write-plot 
     (clnuplot:make-plot  
      :lines-points 
      '((1 2) (2 2.5) (3 3.1) (4 3.4) (5 4.2))
      :pointsize 2.0
      :linewidth 3.0
      :filename "simple-example"
      :xlabel "Bin Number"
      :ylabel "Dance Partners"
      :x-coord #'first
      :y-coord #'second
      :title "Bin Number versus Dance Partners"
      :ymin 0.0)
     :pdf)

Produces
 
<img href="simple-example.png" width="320"></img>

{anchor mailing-lists}

### Mailing Lists

Nope. Sorry, there isn't one. You can, however, contact [Gary King][8].

{anchor downloads}

### Where is it

CLNUPlot is on the [CLiki][9]. A [Darcs][10] repository is available. The command to get it is below:
    
    darcs get http://common-lisp.net/project/cl-containers/clnuplot/darcs/clnuplot
    

CLNUPlot is also [ASDF installable][11] (and here is my [GPG Key][12]). 
This is probably a better way to get it since it has several dependencies.
There's also a handy [ gzipped tar file][13].

{anchor news}

### What is happening

19 October 2007 Mostly minor housecleaning; added trivial-shell dependency to make things easier.

3 January 2006 Just getting things set up here.

</div>
</div>

{include resources/footer.md}

   [1]: http://common-lisp.net/project/cl-containers/shared/metabang-2.png (metabang.com)
   [2]: http://www.metabang.com/ (metabang.com)
   [3]: #mailing-lists
   [4]: #downloads
   [5]: documentation/ (documentation link)
   [6]: #news
   [7]: changelog.html
   [8]: mailto:gwking@metabang.com
   [9]: http://www.cliki.net/clnuplot
   [10]: http://www.darcs.net/
   [11]: http://www.cliki.net/asdf-install
   [12]: http://www.metabang.com/public-key-gwking.html
   [13]: http://common-lisp.net/project/cl-containers/clnuplot/clnuplot_latest.tar.gz
   [14]: http://common-lisp.net/project/cl-containers/shared/buttons/xhtml.gif (valid xhtml button)
   [15]: http://validator.w3.org/check/referer (xhtml1.1)
   [16]: http://common-lisp.net/project/cl-containers/shared/buttons/hacker.png (hacker emblem)
   [17]: http://www.catb.org/hacker-emblem/ (hacker)
   [18]: http://common-lisp.net/project/cl-containers/shared/buttons/lml2-powered.png (lml2 powered)
   [19]: http://lml2.b9.com/ (lml2 powered)
   [20]: http://common-lisp.net/project/cl-containers/shared/buttons/lambda-lisp.png (ALU emblem)
   [21]: http://www.lisp.org/ (Association of Lisp Users)
   [22]: http://common-lisp.net/project/cl-containers/shared/buttons/lisp-lizard.png (Common-Lisp.net)
   [23]: http://common-lisp.net/ (Common-Lisp.net)

