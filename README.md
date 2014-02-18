# LazyScraper

[![Build Status](https://travis-ci.org/bfontaine/LazyScraper.png)](https://travis-ci.org/bfontaine/LazyScraper)
[![Coverage Status](https://coveralls.io/repos/bfontaine/LazyScraper/badge.png)](https://coveralls.io/r/bfontaine/LazyScraper)

LazyScraper is the easy way to define lazy entity-oriented Web scrapers.

Note: This is only a proof-of-concept.

## Usage

Let’s say we want to fetch some reviews from FooBar website (which doesn’t have
a public API). Reviews are located at `'/review?product_id=something'` (we’ll
leave the domain part here).

We start by creating a class which inherit from `LazyScraper::Entity`:

```rb
class FooBarReview < LazyScraper::Entity
end
```

Then we’ll add some hooks. A hook map a set of attributes to an URL with a
parser.  This is used to ensure that a webpage is fetched & parsed only once,
and only at the right time. Here, we’ll assume that each review has a product id
we know, a product name, a score, and a text. They are all located on the
same page, but LazyScraper also support hooks on multiple URLs.

```rb
class FooBarReview < LazyScraper::Entity
  attr_hook '/review?product_id=:product_id',
    :product_name, :score, :text do |doc, attrs|

    attrs[:product_name] = doc.css('#product .name').text
    attrs[:score]        = doc.css('#score').text.to_i
    attrs[:text]         = doc.css('#text').text
  end
end
```

Here, `attr_hook` takes the path to the page, with a `:product_id` placeholder,
which will later be replaced by the actual `product_id` of a review. Then, we
gives it the list of attributes which depends on this webpage. This way, the
page will be fetched and parsed *only* the first time we access one of the
attributes. The last argument is a block which takes a Nokogiri document and a
hash we’ll populate in it.

That’s all, we can now try our class:

```rb
# note how we’re given the product id
lazy_review = FooBarReview.new :product_id => 42

# we haven’t fetched the page yet

lazy_review.text  # this fetches the page and return the text
lazy_review.score # this returns the score without fetching the page again
```

