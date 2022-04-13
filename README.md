Amazon Scraper
================

This is a guide for R users to automate the copy-paste into a dataset
(scrape) of public user-generated content on Amazon. In this example we
will scrape the reviews of the users to a jar of italian pesto, but this
guide will help you to understand how to efficiently download many kind
of public information from websites.

### Packages

I use a very efficient package for installing and loading the necessary
packages for scraping, that is `pacman`. In particular,
`pacman::p_load(name_of_package_1, name_of_package_2,...)` will check if
the packages are installed and, if not, it will install them.

``` r
pacman::p_load(tidyverse,rvest)
```

# rvest is a great scraper!

To my knowledge, there are essentially 3 free software for scraping
things on Internet. We are going to use `rvest`. It is quite easy,
intuitive and well-responding. Alternatives are `BeautifulSoup` for
Python and Selenium (`RSelenium`). `BeautifulSoup` is conceptually the
same of `rvest` so it’s only a matter of personal taste, but Selenium
and `rvest` works differently.

`rvest` will connect R to the back-end code of any adress where you send
it. It always work on crawling the whole code behind a internet page and
then your code will select only the user-generated content of interest.

Selenium will set up a bot crawler on a browser that can be guided to
perform some actions and literally copy-past elements front-end of the
internet page.

In my experience, once setup correctly, Selenium can be even more
responsive than `rvest`, because what you (would) see is what you (will)
get. This is very useful for scraping websites that relies heavily on
Javascripts.

For example, I had to use Selenium to scrape Adults Only content on the
website Steam, because to access to the back-code of 18+ content one
have before to click on a button of consent. To my knowledge, while
`rvest` has a syntax for interacting with elements of front-end, I was
never truly able to make it work consistently.

However, I also feel that a correct setup of Selenium is a pain in the
ankle to code, and that `rvest` is an excellent beginning. Overall,
since Selenium have to synchs to a browser, is also slower than `rvest`.

## rvest main commands

The main commands of rvest are:

-   `read_html(URL)`: this commands R to go to a URL and to start
    watching for the back code of that website addressed at the `URL`.
-   `html_elements("selector")`: this is just a filter. To code
    correctly how to word the `("selector")` is the hard part of any
    scraping activity. In my opinion, is mostly a work of deduction and
    reverse engineering. I think that techniques for deducting the
    correct selector almost need a guide on their own, but I will try to
    give my mental tips at the end of this one.
-   `html_text()`: this will just convert your selection of elements in
    a vector of `character`. Sometimes you don’t want a `character`, but
    a `numeric`, but in my opinion having everything scraped as text
    before pre-processing text will help a lot debugging and it’s
    generally a good practice.

# Scraping pesto!

In this example we want to collect the reviews for a jar of italian
pesto. In particular, we will scrape the reviews from Amazon.it, that is
the Italian Amazon.

So, we need to set the `URL` of `read_html()` as the address of the
webpage for the reviews

``` r
URL = "https://www.amazon.it/product-reviews/B00XUGZRL8/ref=cm_cr_getr_d_paging_btm_next_2?ie=UTF8&filterByStar=all_stars&reviewerType=all_reviews&pageNumber="

read_html(URL)
```

    ## {html_document}
    ## <html lang="it-it" class="a-no-js" data-19ax5a9jf="dingo">
    ## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8 ...
    ## [2] <body>\n<span id="cr-state-object" data-state='{"asin":"B00XUGZRL8","devi ...

Now, in theory, we could proceed to select only the part of content of
our interest, for example the text of the reviews:

``` r
read_html(URL) %>%
  html_elements(".review-text-content span") %>%
  html_text() -> reviews

reviews %>% head(2)
```

    ## [1] "Almeno una volta a settimana sono abituato a mangiare un piatto di pasta con il pesto…ne ho provati tantissimi (ho persino provato a farlo a casa con risultati appena sufficienti!).Questo Barilla, un nome altisonante nell’ambito dell’industria alimentare, ha suscitato il mio interesse.Un pesto dentro un barattolo di vetro sigillato che vanta la nomea di essere alla genovese.Devo dire che appena aperto, già dalla consistenza, non mi ha ispirato tantissima simpatica.Sembra più che altro una crema e questo si traspone nel momento andiamo a mescolarlo con la pasta: si avrà una crema biancastra mischiata col verde del basilico “atomizzato”. Credo sia dovuto al latte in polvere e alcuni suoi derivati usati come aromi mischiati negli ingredienti!Il sapore è molto sapido ma non so se sia colpa del sale, del troppo formaggio o di entrambi.Purtroppo non ho scorto l’ombra di pinoli, sostituiti dagli più economici anacardi tritati a fine granella.L’amalgama con la pasta sarà assicurato ma niente di che…un sapore forte che ha poco a che fare col vero pesto. Altri brand concorrenti fanno meglio…primo fra tutti il famoso Rana.Per la mia esperienza, visto il prezzo per 190g di 1,75\200 (discreto) ed il sapore (sufficiente), do un voto di 6,7/10 => 3 stelle nel rapporto qualità/prezzo."
    ## [2] "E dunque buongiorno innanzitutto, oggi per la prima volta ho provato il pesto \"industriale\". Ero molto scettico in quanto sono uno fissato per preparare le conserve in casa, pur non essendo ligure, ma conservando le buone vecchie tradizioni.Quest'anno il basilico non era eccellente per cui non ho preparato il pesto.In quanto adoro la pasta al pesto ho deciso di comprarlo su Amazon.Il gusto è davvero eccezionale il mix di ingredienti, ben dosati tra loro, hanno reso la pasta saporita e condita al punto giusto.La convenienza e la praticità di prenderlo da Amazon non ha paragoni.Consegna impeccabile, precisa e gratuita con Prime."

### Sometimes you want to scrape a link.

More in general, sometimes you want to scrape an `html`-attribute. What
is an attribute? Is a code that modifies or ‘augment’ the front-end of
the content called in the code. Most of the times, you just want to
scrape a link, that is exactly an augment of a text or an image.

For example, for linking something in Markdown, the language behind this
document, you have to back-end this format: `[text](link)`. Taking this
metaphor in mind, the equivalent in `rvest` would be to select
(`html_elements`) the `[text]`, but then to extract the `(link)`
attribute, not the text in itself. In `rvest`, this is done with the
command `html_attr("href")`.

``` r
read_html(URL) %>%
  html_elements("#cm_cr-review_list .a-profile") %>%
  html_attr("href")
```

    ##  [1] "/gp/profile/amzn1.account.AEJ5W75HK3VXWYKK2XHU75GGRWZA/ref=cm_cr_arp_d_gw_btm?ie=UTF8"
    ##  [2] "/gp/profile/amzn1.account.AEJ5W75HK3VXWYKK2XHU75GGRWZA/ref=cm_cr_arp_d_gw_pop?ie=UTF8"
    ##  [3] "/gp/profile/amzn1.account.AFYAZWPWIUBL6JA7VL6C55RT6GSQ/ref=cm_cr_arp_d_gw_btm?ie=UTF8"
    ##  [4] "/gp/profile/amzn1.account.AFYAZWPWIUBL6JA7VL6C55RT6GSQ/ref=cm_cr_arp_d_gw_pop?ie=UTF8"
    ##  [5] "/gp/profile/amzn1.account.AGJOT5T6XT2OWTXMS2LGFAL3F4RA/ref=cm_cr_arp_d_gw_btm?ie=UTF8"
    ##  [6] "/gp/profile/amzn1.account.AGJOT5T6XT2OWTXMS2LGFAL3F4RA/ref=cm_cr_arp_d_gw_pop?ie=UTF8"
    ##  [7] "/gp/profile/amzn1.account.AEZKHX736VTPTYNF3KR72ZMBW6QQ/ref=cm_cr_arp_d_gw_btm?ie=UTF8"
    ##  [8] "/gp/profile/amzn1.account.AEZKHX736VTPTYNF3KR72ZMBW6QQ/ref=cm_cr_arp_d_gw_pop?ie=UTF8"
    ##  [9] "/gp/profile/amzn1.account.AHBBITMVHK6Z32CW7PXH5SBW4J2Q/ref=cm_cr_arp_d_gw_btm?ie=UTF8"
    ## [10] "/gp/profile/amzn1.account.AGA5KPSKHXMH7N5G4T5PXI7GSZQA/ref=cm_cr_arp_d_gw_btm?ie=UTF8"
    ## [11] "/gp/profile/amzn1.account.AGA5KPSKHXMH7N5G4T5PXI7GSZQA/ref=cm_cr_arp_d_gw_pop?ie=UTF8"
    ## [12] "/gp/profile/amzn1.account.AEYXAAQM4LEZNZL5XD4NIPG2ZKUQ/ref=cm_cr_arp_d_gw_btm?ie=UTF8"
    ## [13] "/gp/profile/amzn1.account.AEYXAAQM4LEZNZL5XD4NIPG2ZKUQ/ref=cm_cr_arp_d_gw_pop?ie=UTF8"
    ## [14] "/gp/profile/amzn1.account.AHTFZW3VSZ27SLI3MHAYX4I2UGGA/ref=cm_cr_arp_d_gw_btm?ie=UTF8"
    ## [15] "/gp/profile/amzn1.account.AHTFZW3VSZ27SLI3MHAYX4I2UGGA/ref=cm_cr_arp_d_gw_pop?ie=UTF8"
    ## [16] "/gp/profile/amzn1.account.AFCLJKUDUAK62UEODAEWBHMQERVQ/ref=cm_cr_arp_d_gw_btm?ie=UTF8"
    ## [17] "/gp/profile/amzn1.account.AHHRODKEHXRIZHA7NS4WREPMQD3A/ref=cm_cr_arp_d_gw_btm?ie=UTF8"

This is a list of all the times that `rvest` finds a list of link
associated to usernames, in the list of reviews for that URL. We would
expect only a list of 10 elements, but it may be more. This is because
Amazon code is not exactly very tidy, so I wrapped the code with a fix
that will leave only unique links.

``` r
read_html(URL) %>%
  html_elements("#cm_cr-review_list .a-profile") %>%
  html_attr("href") %>%
  str_remove("\\/ref.*") %>%
  unique()
```

    ##  [1] "/gp/profile/amzn1.account.AEJ5W75HK3VXWYKK2XHU75GGRWZA"
    ##  [2] "/gp/profile/amzn1.account.AFYAZWPWIUBL6JA7VL6C55RT6GSQ"
    ##  [3] "/gp/profile/amzn1.account.AGJOT5T6XT2OWTXMS2LGFAL3F4RA"
    ##  [4] "/gp/profile/amzn1.account.AEZKHX736VTPTYNF3KR72ZMBW6QQ"
    ##  [5] "/gp/profile/amzn1.account.AHBBITMVHK6Z32CW7PXH5SBW4J2Q"
    ##  [6] "/gp/profile/amzn1.account.AGA5KPSKHXMH7N5G4T5PXI7GSZQA"
    ##  [7] "/gp/profile/amzn1.account.AEYXAAQM4LEZNZL5XD4NIPG2ZKUQ"
    ##  [8] "/gp/profile/amzn1.account.AHTFZW3VSZ27SLI3MHAYX4I2UGGA"
    ##  [9] "/gp/profile/amzn1.account.AFCLJKUDUAK62UEODAEWBHMQERVQ"
    ## [10] "/gp/profile/amzn1.account.AHHRODKEHXRIZHA7NS4WREPMQD3A"

Much tidier, right?

In theory, you can also extract all the attributes of the selected
content with `html_attr()`, but I don’t think it’s really useful.

# Ready for scraping the whole thing?

There are a bunch of issues to solve, here:

-   It only scraped 10 reviews. Why?
-   This text has no author, no date, no score…

Let’s solve these issue!

## Infer the number of pages to scrape

The scraper downloaded only 10 reviews because in the URL that I
provided there are those 10. There are other reviews for the jar of
pesto in Amazon, but they are in other URLs. Luckily, it’s quite easy to
infer where these are…

For example…

``` r
read_html(URL %>% str_c("2")) %>%
  html_elements(".review-text-content span") %>%
  html_text() -> reviews

reviews %>% head(2)
```

    ## [1] "Barilla con il proprio pesto alla genovese non si smentisce mai, molto ma molto buono sopratutto questo senza aglio, sarà che a me l'aglio non fa tanto impazzire ma preferisco questo. Certo non sarà equiparabile al classico ragu' fatto in casa questo è normale, ma il sapore è parecchio buono e sopratutto molto profumato.Non è necessario riscaldarlo in quanto una volta pronta la pasta, che siano spaghetti o penne, lo si mette dentro e si mescola il tutto, io personalmente anzi faccio tutt'altro, lo lascio in frigo e lo verso quando il prodotto è freddo, con un vasetto da 190gr riesco a fare circa 4 piatti, sì lo metto molto abbondante lo so.Questo pesto ovviamente si trova in qualunque market ma ho preferito acquistarlo qui su amazon per via ovviamente, del suo prezzo molto concorrenziale.Un vasetto di pesto molto buono che non vi farà rimpiangere quello fatto in casa, sicuramente continuerò ad acquistarlo, consigliato.Spero di esservi stato d'aiuto con la mia recensione.Salvatore S."
    ## [2] "Io sono una vera amante del pesto e solitamente prendo quello classico, ma stavolta ho voluto provare quello senza aglio. Sono davvero sorpresa dal sapore e devo dire che, a differenza di quanto si legge, non l’ho trovato per niente molto salato; anzi corretta sapidità, ottimo sapore e ottima cremosità. Ovviamente è un pesto molto commerciale e quindi al posto dei classici pinoli tra gli ingredienti vedrete la presenza arachidi. Peccato perché comunque il costo, non in offerta, è comunque abbastanza elevato. Io questi prodotti li compro qui su Amazon quando sono in offerta. Comunque lascio 4 stelle perché per me è un buon rapporto qualità prezzo, se preso in offerta; qualitativamente lo trovo buono e il sapore è ottimo.Consegna Amazon accurata: il barattolo è avvolto in un involucro di sicurezza e poi messo nella scatola di cartone. Tempi di consegna rispettati."

I only added a number after the URL, now th scraper know that it has to
go to page 2 of reviews. Almost all websites are organized exactly in
this way. I already pre-coded the URL of Amazon in a way that I only
need to add one number to jump into that webpage, and you should try to
do the same, understanding the structure of the URL code.

`https://www.amazon.it/product-reviews/B00XUGZRL8/ref=cm_cr_getr_d_paging_btm_next_2?ie=UTF8&filterByStar=all_stars&reviewerType=all_reviews&pageNumber=`

In this case `&pageNumber=` ends the address; this is the reason why the
trick with %&gt;% str\_c(“2”) works. You should adapt to the website
that you want to scrape and arrange accordingly the address. Usually
website have front-ends elements, like buttons or drop-down menus that
will help you with it.

So, which is the number of pages for the jar of pesto?

On Amazon it is not explicit, however it is explicit the number of
written reviews, that can be selected from the main `URL` with a
specific selector.

``` r
read_html (URL) %>%
  html_node("#filter-info-section span") %>% html_text
```

    ## [1] NA

The information is here, but we need to polish it. The number we are
looking for is “290 recensioni globali”.

``` r
read_html (URL) %>%
  html_elements("#filter-info-section span") %>% html_text %>% word(25) %>%
  as.integer() -> nrev
nrev
```

    ## [1] 290

Finally, if for each 10 reviews will be generated a new page on Amazon,
then the number of pages is…

``` r
ceiling(nrev / 10) -> lastpage
lastpage
```

    ## [1] 29

## The best way to organize a scraped dataset

Information on timestap, author, text and score goes in parallel, in the
sense that there is one author per review, etc.

The ideal data structure to organize parallel observation of different
features is the `tibble`, and it is certainly viable to just declare a
`tibble` with a fixed number of row and then fill it procedurally with
the scraped content.

However, I think that the best method is to fill separate `vectors` and
only after the scraping to convert them in a `tibble`. For many
`vectors`, the good practice is to organize them in a `list` and then
convert the `list` into a `tibble`. I do not like to work with `list`
syntax, and `list` are very annoying to browse, but once the coding is
done the whole operations are much more smooth.

``` r
reviews = list()
```

``` r
for (i in 1:lastpage) {
  
read_html(URL %>% str_c(i)) -> x
  
reviews$Product[(1+(i-1)*10):(i*10)] = "Pesto Jar"
  
    # Timestamp  
  x %>% html_elements("#cm_cr-review_list .review-date") %>%
    html_text() -> reviews$Time[(1+(i-1)*10):(i*10)]
  
    # Userpage link
  x %>% html_elements("#cm_cr-review_list .a-profile") %>%
  html_attr("href") %>%
  str_remove("\\/ref.*") %>%
  unique() -> reviews$User[(1+(i-1)*10):(i*10)]
  
    # Score
  x %>% html_elements("#cm_cr-review_list .review-rating") %>%
    html_text() -> reviews$Score[(1+(i-1)*10):(i*10)]
  
    # Comment
  x %>% html_elements(".review-text-content span") %>%
    html_text() %>% .[. != ""] -> reviews$Text[(1+(i-1)*10):(i*10)]
}
```

``` r
db = as_tibble(reviews)
db
```

    ## # A tibble: 290 x 5
    ##    Product   Time                                     User           Score Text 
    ##    <chr>     <chr>                                    <chr>          <chr> <chr>
    ##  1 Pesto Jar Recensito in Italia il 11 febbraio 2021  /gp/profile/a~ 3,0 ~ "Alm~
    ##  2 Pesto Jar Recensito in Italia il 6 novembre 2020   /gp/profile/a~ 5,0 ~ "E d~
    ##  3 Pesto Jar Recensito in Italia il 26 novembre 2021  /gp/profile/a~ 4,0 ~ "Un ~
    ##  4 Pesto Jar Recensito in Italia il 12 luglio 2021    /gp/profile/a~ 5,0 ~ "Amo~
    ##  5 Pesto Jar Recensito in Italia il 11 settembre 2019 /gp/profile/a~ 5,0 ~ "L'h~
    ##  6 Pesto Jar Recensito in Italia il 12 gennaio 2021   /gp/profile/a~ 5,0 ~ "La ~
    ##  7 Pesto Jar Recensito in Italia il 7 gennaio 2022    /gp/profile/a~ 4,0 ~ "Ess~
    ##  8 Pesto Jar Recensito in Italia il 7 gennaio 2021    /gp/profile/a~ 5,0 ~ "Son~
    ##  9 Pesto Jar Recensito in Italia il 13 novembre 2021  /gp/profile/a~ 2,0 ~ "Del~
    ## 10 Pesto Jar Recensito in Italia il 10 ottobre 2021   /gp/profile/a~ 5,0 ~ "Acq~
    ## # ... with 280 more rows

Yes, the `db` needs a bit more of cleaning, but this is higly dependent
by the Amazon website you are going to scrape. These data are in
Italian. In my experience the different languages requires slightly
different workflows, and unfortunately I cannot say that the selectors
in `html_elements` are the same across languages…

### Why a for cycle?

Why a `for` cycle and not something fancier, like a `map_*`? In my
experience, everytime you have to connect to a website you always want a
slow, procedural, controlled `for` cycle.

# Tell me more about CSS selectors

There are two ways for fishing for selectors:

-   [SelectorGadget](https://chrome.google.com/webstore/detail/selectorgadget/mhjhnkcfbdhnjickkkdbjoemdmbfginb)
-   Inspecting the back-end code of the webpage

My suggestion is to watch a video-guide on SelectorGadget and start
playing with it in simpler websites. Amazon is not very simple. The key
idea to memorize is that you always start highliting in green something
in the front-end that you want to scrape for sure, then you localize
elements that you want to be out of the selection. SelectorGadget will
highlight these in red. In the end it should provide a CSS selector code
to insert in the `html_elements()` command.

Personally, I prefer go searching within the `html` code of the page. My
strategy is something like this:

-   I decide an example of front-end text that I want to scrape
-   I look for the position of that text in the back-end code
-   I try to deduce the class (`class=something`) of that elements.
    Often that class is in common with all the other elements with the
    same functions (e.g. the score)
-   `html_elements(".something")`

Sometimes I need to scrape `html_elements(".something")` only within a
section of the page; for example, look in the code above that I select
with:

`html_elements("#cm_cr-review_list .review-rating")`

The function of `#cm_cr-review_list` is to limit the selection only
within a section of the webpage called `cm_cr-review_list` in the `html`
code of the webpage.

# Why to limit only to a jar of pesto?

In theory, every single product on Amazon can be scraped. Sometimes it
is useful to make a collection of similar items.

There are many ways to do so. I think that the most reliable would be to
collect in a `tibble`:

-   the product ID (e.g. “Pesto Jar”)
-   all the webpages associated to their `pageNum`
-   the lastpage for each ID

Let’s name this `tibble` as `URL_list`

Then , instead of reading the `html` code from

`read_html(URL %>% str_c(i)) -> x`

the `for` cycle would iterate `x` across

`read_html(URL_list$URL[i]) -> x`.

The final `db` would look like this:

``` r
tibble(Product = c("Pesto Jar","Pesto Jar","Tuna Can"),
       Time = c("Monday","Tuesday","Sunday"),
       User = c("Donald","Goofy","Donald"),
       Score = c(4,5,2)
)
```

    ## # A tibble: 3 x 4
    ##   Product   Time    User   Score
    ##   <chr>     <chr>   <chr>  <dbl>
    ## 1 Pesto Jar Monday  Donald     4
    ## 2 Pesto Jar Tuesday Goofy      5
    ## 3 Tuna Can  Sunday  Donald     2
