[![Built.io Contentstack](https://contentstackdocs.built.io/static/images/logo.png)](https://www.built.io/products/contentstack/overview)

# Ruby SDK for Built.io andContentstack

Ruby client for [built.io](https://www.built.io)'s [Contentstack](https://www.built.io/products/contentstack/overview)  - the API-first CMS for your app. This SDK interacts only with the [Content Delivery Rest API](https://contentstackdocs.built.io/developer/restapi).

Contentstack is the CMS without the BS. With this headless cms, developers can build powerful cross-platform applications using their favorite front-end javascript frameworks and Android/iOS clients. 

You build your front-end and we will take care of delivering content through APIs, optimized for each destination. - [more here](https://www.built.io/products/contentstack/overview) 

##### [TODOS]

[-] sign up link missing
[-] add logos for react, angular, iOS and Android

## Prerequisite
You only need ruby v2.0 or later installed to use the Built.io Contentstack SDK.

## Setup and Installation
Add this to your application's Gemfile and `bundle`:

```bash
gem 'contentstack'
```

Or you can run this command in your terminal (you might need administrator privileges to perform this installation):

```ruby
gem install contentstack
```

To start using the SDK in your application, you will need to initialize the stack by providing the required keys and values associated with them.

```ruby
client = Contentstack::Client.new(
  api_key: ''
  access_token: 'b4c0n73nExample',
  environment: ''
)
```

##### [TODOS]
[-] Add a DSL for easier more idiomatic configuration


## Key Concepts for using Contentstack

### Stack
A stack is like a container that holds the content of your app. Learn more about creating stacks. [watch videos tutorials with documentation](https://contentstackdocs.built.io/developer/javascript/quickstart)

### Content Type

A content type is the structure of a section with one or more fields within it. It is a form-like page that gives Content Managers an interface to input and upload content. 

### Entry

An entry is the actual piece of content created using one of the defined content types. 

### Asset

Assets refer to all the media files (images, videos, PDFs, audio files, and so on) uploaded to Built.io Contentstack. These files can be used in multiple entries.  

### Environment

A publishing environment corresponds to one or more deployment servers or a content delivery destination where the entries need to be published. 


## 5 minute Quickstart

### Initializing your Stack client
To initialize a Stack client, you need to provide the required keys and values associated with them:

```ruby
stack = Contentstack::Client.new(
  api_key: ''
  access_token: 'b4c0n73nExample',
  environment: ''
)
```

To get the api credentials mentioned above, you need to log into your Contentstack account and then in your top panel navigation, go to Settings -> Stack to view both your `API Key` and your `Access Token`


The `stack` object that is returned a Built.io Contentstack client object, which can be used to initialize different modules and make queries against our [Content Delivery API](https://contentstackdocs.built.io/rest/api/content-delivery-api/). The initialization process for each module is explained below.


### Querying content from your stack

Let us take an example where we try to obtain all entries of the Content Type my_content_type.

```ruby
entry = stack.content_type(<<CONTENT_TYPE_UID>>).query();
```

##### [TODOS]

[-] Where to get your content type and content type uid from
[-] Describe what a preview of the returned `entry` object will look like


Let us take another example where we try to obtain only a specific entry from the Content Type `my_content_type`.

```ruby
entry = stack.content_type(<<CONTENT_TYPE_UID>>).entry(<<ENTRY_UID>>);
```

#### [Todos]
[-] Describe what a preview of the returned `entry` object will look like


## More Usage

You can query for content types, entries, assets and more using our completely documented api. Here are some useful examples:

This is how you get all the `ContentTypes` in your stack:

```ruby
content_types = stack.content_types
```

Get a specific `ContentType` by `content_type_uid`

```ruby
blog_entries = stack.content_type('blog');
```

Get a specific `Entry` by `entry_uid`

```ruby
blog_entry = stack.content_type('blog').entry('blt1234567890abcef')
```

Fetch all entries of requested `content_type`


## Next steps

- [Online Query Guide](https://contentstackdocs.built.io/developer/javascript/query-guide)
- [Online API Reference (ruby examples coming soon)](https://contentstackdocs.built.io/js/api/)

## Links
 - [Website](https://www.built.io/products/contentstack/overview)
 - [Official Documentation](http://contentstackdocs.built.io/developer/javascript/quickstart)
 - [Content Delivery Rest API](https://contentstackdocs.built.io/developer/restapi)

## The MIT License (MIT)
Copyright © 2012-2016 [Built.io](https://www.built.io/). All Rights Reserved

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.