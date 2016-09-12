# Adtek.io Adnetworks

Dealing with Mobile Advertising Networks can be a non-trivial task, especially
when it comes to integrating them into reporting tools: each has their own
report APIs, each of which return their own report-data format.

On top of that, each has its own authentication methods, making it difficult
to obtain the right credentials for the right report. Where possible, this
gem provides scrapers for adnetworks to obtain API credentials in a transparent
and common manner.

## Raison d'être

Why this gem? The aim is to make mobile advertising and mobile user acquistion
more flexible and cost effective.

In a sense, this gem can help become your own mobile adnetwork aggregator
by allowing you to easily try out new adnetworks without having to integrate
their respective SDKs. The gem also provides the raw data for comparing the
performance of adnetworks and allowing you to make informed choices.

Of course, on its own, this gem does does not provide the complete picture.
What this gem does is provide the raw data in a unified manner so that other
tools can provide aggegration and comparisons across a number of
adnetworks. One such tool is [adtek.io][adtek] which provides the neccessary
infrastructure for flexibility and cost effectiveness for mobile
marketing and user acquistion.

On a technical level, this gem aggregates together all code related to
interfacing with the adnetworks. This includes importing their reporting
data, obtaining their [API][api] credentials (which are often confusing and
difficult to obtain) and providing networks with user tracking data so that
they can continue to optimise their campaigns.

## Features

This gem provides four main features when dealing with mobile advertising
networks (adnetworks):

1. [Spends importers][simp] which retrieve spending reports from
   various networks.

2. [Revenue importers][rimp] which retrieve revenue reports from various
   adnetworks.

3. [API Key Scrapers][apsc] aim to obtain the API credentials using the login
   details of the adnetwork. That is to say, they automate the retrieval of
   API credentials from adnetworks where possible.

   So when an adnetwork says something like: ```To obtain your API key, first
   login, then go to your profile page, then click API key ...``` etc, a
   scraper will automagically do that to obtain the API credentials.

4. [Postbacks][pblnk] provide callback links for various adnetworks so
   that user tracking does not come from the mobile application but
   from a backend server. Making the need to integrate a adnetworks
   [SDK][sdk] redundant.

## Integration

To include the gem in your project, add this to your favourite Gemfile:

```
gem 'adtekio_adnetworks', :github => "adtekio/adnetworks"
```

then run bundle and require the gem:

```
require 'adtekio_adnetworks'
```

## Usage

You can play around with the gem by cloning it and then running a
[pry][pry] shell:

```
git clone git@github.com:adtekio/adnetworks.git
cd adnetworks
bundle
rake shell
```

Ideally you are using either [rbenv][rbenv] or [rvm][rvm] to isolate your ruby
versions and gemsets.

### Spends Importers

*Note:* 'Spends Importer' and 'Cost Importer' are used interchangeably but
represent the same thing: the money spent on marketing and user acquistion.

Each cost importer is registered with the `AdtekioAdnetworks::CostImport`
class, from there you can get a complete list of supported adnetworks:

```
pry> AdtekioAdnetworks::CostImport.networks
=> {:adcolony=>AdtekioAdnetworks::Cost::Adcolony,
 :adquant=>AdtekioAdnetworks::Cost::Adquant,
 :appia=>AdtekioAdnetworks::Cost::Appia,
 :applifier=>AdtekioAdnetworks::Cost::Applifier,
 :applift=>AdtekioAdnetworks::Cost::Applift,
 :applovin=>AdtekioAdnetworks::Cost::Applovin,
 :bidmotion=>AdtekioAdnetworks::Cost::Bidmotion, ....
```

This returns a hash with network-name/importer-class pairs of all
supported cost importers.

Each importer requires credentials to obtain the costs, to find out
what is required, you use the `required_credentials` class method:

```
pry> importer_klass = AdtekioAdnetworks::CostImport.networks[:adcolony]
=> AdtekioAdnetworks::Cost::Adcolony
pry> importer_klass.required_credentials
=> [:api_key]
```

In this example, adcolony requires an api_key. This can either be obtained
directly from adcolony or using [the corresponding api_scraper][adcapsc].

So having obtained the `api_key`, we can now use it by assigning the
credentials (using a hash instance):

```
pry> importer = importer_klass.new
=> #<AdtekioAdnetworks::Cost::Adcolony:0x007f822a051730>
pry> importer.credentials = { :api_key => "xxx" }
=> {:api_key=>"xxx"}
```

After that, to obtain the costs/spends for the last five days:

```
pry> importer.campaign_costs(Date.today-5, Date.today)
=> [{:date=>..., :campaign=>"xx", :adgroup=>"xx", :impressions=>..., :clicks=>..., :conversions=>..., :amount=>..., :target_country=>"..."},
...etc
```

The result is always an array of hashes. Hash can be different from importer
to importer, however they always include the `amount`, `date`, `campaign`,
and `clicks`.

This interface applies to all cost importers, they have the same interface but
different credentials.

### Revenue Importers

Revenue importers retrieve data related to the revenue your mobile
application is making by showing advertising to your users. Basically
your revenue for an adnetwork is offsetting the cost for using that
adnetwork.

You might think that is wonderful, but you have to think about what
advertising they are showing your users. It might well be advertising for
your competition, so that you the revenue you are obtaining is actually
compensation for losing your users.

Using the revenue importers is very similar to using the cost importers,
first you get a list of supported adnetworks:

```
pry> AdtekioAdnetworks::RevenueImport.networks
=> {:adcolony=>AdtekioAdnetworks::Revenue::Adcolony,
 :applifier=>AdtekioAdnetworks::Revenue::Applifier,
 :applovin=>AdtekioAdnetworks::Revenue::Applovin,
 :chartboost=>AdtekioAdnetworks::Revenue::Chartboost, ....
```

Then you choice one for which you would like to import the revenue data:

```
pry> importer_klass = AdtekioAdnetworks::RevenueImport.networks[:chartboost]
=> AdtekioAdnetworks::Revenue::Chartboost
pry> importer_klass.required_credentials
=> [:user_id, :signature]
```

So we see that we need a `user_id` and `signature` for Chartboost. Since
we only have our login details, we can use the API key scraper to obtain
the user_id and signature:

```
pry> login_details = { "username" => "xxx", "password" => "yyy" }
=> {"username"=>"xxx", "password"=>"yyy"}
pry> creds = AdtekioAdnetworks::ApiKeyScrapers.new.obtain_key_for("chartboost", login_details)
=> {"user_id"=>"zzz", "signature"=>"aaa"}
```

Now we can start the chartboost revenue importer for the last five days:

```
pry> importer = importer_klass.new
=> #<AdtekioAdnetworks::Revenue::Chartboost:0x007ff1039c3460>
pry> importer.credentials = creds
=> {"user_id"=>"zzz", "signature"=>"aaa"}
pry> importer.revenues(Date.today-5, Date.today)
=> [{:impressions=>...,
  :amount=>...,
  :date=>...,
  :appname=>....,
  :not_matched=>....},
```

What the revenue importer returns is an array of hashes containing amounts
and dates. Data is always aggregated by day.

For other adnetworks it is very similar, so just rinse and repeat for all
the adnetworks you have.

### API Key Scrapers

Providing a unified method of obtaining API credentials. Since most adnetworks
do not use login details for their APIs, a user always has to obtain an
their API credentials from the adnetworks.

Since this can be a confusing task (since most adnetworks squirrel their
API credentials away somewhere non-intuitive) but using an API scraper,
this becomes as easy as providing username & password and pressing a
button!

All [supported adnetworks][libscp] all have the same interface:

```
pry> scraper = AdtekioAdnetworks::ApiKeyScrapers.new
pry> login_details = {"username" => "username used to login", "password" => "password used to login" }
pry> credentials = scraper.obtain_key_for("applift",login_details))
```

The `login_details` is always a hash with "username" and "password" as key.
Username is whatever the adnetworks requires to login, i.e it could be
an email or a username or a banana, whatever is required by the adnetwork.

`obtain_key_for` always returns a hash but what it contains is adnetwork
specific. However, for those adnetworks that return one value (i.e. an api
key or token), the hash always is for the form `{ :token => 'api key value' }`.

To get a list of all supported networks:

```
pry> AdtekioAdnetworks::ApiKeyScrapers.supporter_adnetworks
=> ["adcolony", "applift", "applovin", "chartboost", "crossinstall", "leadbolt", "loopme", "mdotm", "revmob", "tapjoy", "unilead", "vungle"]
```

### Postbacks

Postback definitions need to be seen in the context of how mobile advertising
and user acquistion currently works. Postbacks are very specific and if the
context is not clear, then they make little or no sense!

Currently if you want to mobile advertising for your application, you need
to choose an adnetwork (e.g. adcolony, unilead, etc), sign a deal with them
and integrate their [SDK][sdk] into your application. Then you can start
your campaigns to obtain users.

If you then discover that their campaigns are not performing, you end up
repeating the cycle and integrating some other adnetworks SDK into your
application. In a certain sense, SDKs have become a [vendor lock-in][vnli]
for the mobile marketing sector.

Of course, there are already aggregators on the market (e.g. singular,
adjust, tenjin, etc) however there you have a similar issues except you
are relying on a group of adnetworks chosen by the aggregator. If campaigns
do not perform, you still need to look for something else.

Anyone who has developed an mobile application knows that integrating SDKs
is a non-trival task and, in the case of Apple, results in delays when
releasing an application.

So the question becomes how to avoid the overhead of integrating adnetwork
SDKs but still have the flexibility of trying out different adnetworks?

To answer this, we need to know what these SDKs actually do. Basically they
provide user-tracking data for adnetworks to optimise their campaigns
(and also allow them to build up user profiles since adnetworks collect a
lot of data from lots of mobile applications).

Most (all?) of the time this data, collected from your users, is not
provided to you. Instead, if you are doing [A/B tests][abtst] and trying
to optimise your application for your users, you will be doing your own
user-tracking.

So your application will end up doing duplicate user tracking, which does
seem to be a bit of a waste (even in the digital virtual world).

This is where postbacks come in, they are simply the same tracking calls
that an adnetwork would do except you can trigger them. So now,
putting it all together, the intention is that since you are doing your own
user tracking, you can pass these tracking calls onto the adnetworks from
your tracking server and not from your mobile application.

Everybody wins: no more duplicate tracking from your mobile application,
the adnetworks get their tracking calls (in addition, these can become
more application specific) and the adnetworks can continue to optimise
their campaigns for your application.

If, on the other hand, your are not doing your own user tracking, then
postbacks are no benefit to you whatsoever. However, you could start using
[adtek.io][adtek] which also provides tracking and a single SDK.

## Travis

[![Build Status](https://travis-ci.org/adtekio/adnetworks.svg?branch=master)](https://travis-ci.org/adtekio/adnetworks)

## License

Released under the GPLv2.

See https://www.gnu.org/licenses/gpl-2.0 for details.

## Contributing to Gem

1. Fork it ( https://github.com/adtekio/adnetworks/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Make sure to add tests (`rake test`)
6. Please try not to mess with the Rakefile, version, or history
7. Create new Pull Request

<!-- references, link endpoints, no need to look any further -->
[abtst]: https://en.wikipedia.org/wiki/A/B_testing
[adtek]: https://www.adtek.io
[adcapsc]: /lib/adtekio_adnetworks/api_key_scrapers/adcolony.rb
[api]: https://en.wikipedia.org/wiki/Application_programming_interface
[apsc]: /lib/adtekio_adnetworks/api_key_scrapers
[libscp]: /lib/adtekio_adnetworks/api_key_scrapers
[pblnk]: /lib/adtekio_adnetworks/postbacks
[pry]: http://pryrepl.org/
[rbenv]: https://github.com/rbenv/rbenv
[rimp]: /lib/adtekio_adnetworks/importers/revenue
[rvm]: https://rvm.io/
[sdk]: https://en.wikipedia.org/wiki/Software_development_kit
[simp]: /lib/adtekio_adnetworks/importers/cost
[vnli]: https://en.wikipedia.org/wiki/Vendor_lock-in
