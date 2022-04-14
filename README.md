# **Ruby SDK for Contentstack**

Contentstack is a headless CMS with an API-first approach. It is a CMS that developers can use to build powerful cross-platform applications in their favorite languages. Build your application frontend, and Contentstack will take care of the rest. [Read More](https://www.contentstack.com/). 

Contentstack provides Ruby SDK to build application on top of Ruby on Rails. Given below is the detailed guide and helpful resources to get started with our Ruby SDK.

## **Prerequisite**

You need ruby v2.0 or later installed to use the Contentstack Ruby SDK.

## **Setup and Installation**

Add the following code to your application's Gemfile and bundle:

    gem 'contentstack'

Or you can run this command in your terminal (you might need administrator privileges to perform this installation):

    gem install contentstack

To start using the SDK in your application, you will need to initialize the stack by providing the values for the keys given in the code snippet below.
```ruby
    # with default region
    client = Contentstack::Client.new("api_key", "delivery_token", "enviroment_name")
    
    # with specific region
    client = Contentstack::Client.new("api_key", "delivery_token", "enviroment_name",{"region": Contentstack::Region::EU})
    
    # with custom host
    client = Contentstack::Client.new("api_key", "delivery_token", "enviroment_name",{"host": "https://custom-cdn.contentstack.com"})
```

## **Key Concepts for using Contentstack**

### **Stack**

A stack is like a container that holds the content of your app. Learn more about [stacks](https://www.contentstack.com/docs/guide/stack).

### **Content Type**

Content type lets you define the structure or blueprint of a page or a section of your digital property. It is a form-like page that gives Content Managers an interface to input and upload content. [Read more](https://www.contentstack.com/docs/guide/content-types). 

### **Entry**

An entry is the actual piece of content created using one of the defined content types. Learn more about [Entries](https://www.contentstack.com/docs/guide/content-management#working-with-entries). 

### **Asset**

Assets refer to all the media files (images, videos, PDFs, audio files, and so on) uploaded to Contentstack. These files can be used in multiple entries. Read more about [Assets](https://www.contentstack.com/docs/guide/content-management#working-with-assets). 

### **Environment**

A publishing environment corresponds to one or more deployment servers or a content delivery destination where the entries need to be published. Learn how to work with [Environments](https://www.contentstack.com/docs/guide/environments). 

## **Contentstack Ruby SDK: 5-minute Quickstart**

### **Initializing your SDK**

To initialize the SDK, you need to provide values for the keys given in the snippet below:
```ruby
@stack = Contentstack::Client.new("api_key", "delivery_token", "enviroment_name")
```

To get the API credentials mentioned above, log in to your Contentstack account and then in your top panel navigation, go to Settings > Stack to view the API Key and Access Token.

### **Querying content from your stack**

To fetch all entries of of a content type, use the query given below:
```ruby
@entry = stack.content_type(<<CONTENT_TYPE_UID>>).query();
```

To fetch a specific entry from a content type, use the following query:
```ruby
@entry = stack.content_type(<<CONTENT_TYPE_UID>>).entry(<<ENTRY_UID>>);
```

### Get Multiple Entries
To retrieve multiple entries of a content type, specify the content type UID. You can also specify search parameters to filter results:
```ruby
@query = @stack.content_type('blog').query
@entries = @query.where('title', 'welcome')
                .include_schema
                .include_count
                .fetch
puts "Total Entries -- #{@entries.count}"
@entries.each{|entry| puts "#{entry.get('title')}" }
```

To retrieve localized versions of entries, you can use the query attribute:
```ruby
entry = @stack.content_type('content_type_uid').query.locale('locale_code').fetch()
```
> Note: Currently, the above query works in case of retrieving localized versions of multiple entries only.

## **Advanced Queries**

You can query for content types, entries, assets and more using our Ruby API Reference. 

[Ruby API Reference Doc](http://www.rubydoc.info/gems/contentstack)

### Paginating Responses
In a single instance, the [Get Multiple Entries](https://www.contentstack.com/docs/developers/ruby/get-started-with-ruby-sdk/#get-multiple-entries) query will retrieve only the first 100 items of the specified content type. You can paginate and retrieve the rest of the items in batches using the [skip](https://www.rubydoc.info/gems/contentstack/Contentstack/Query#skip-instance_method) and [limit](https://www.rubydoc.info/gems/contentstack/Contentstack/Query#limit-instance_method) parameters in subsequent requests.

```ruby
@stack = Contentstack::Client.new("api_key", "delivery_token", "environment")
@entries = @stack.content_type('category').query
                .limit(20)
                .skip(50)
                .fetch
```

> Note: Currently, the Ruby SDK does not support multiple content types referencing in a single query. For more information on how to query entries and assets, refer the Queries section of our Content Delivery API documentation.

## **Working with Images**

We have introduced Image Delivery APIs that let you retrieve images and then manipulate and optimize them for your digital properties. It lets you perform a host of other actions such as crop, trim, resize, rotate, overlay, and so on. 

For example, if you want to crop an image (with width as 300 and height as 400), you simply need to append query parameters at the end of the image URL, such as, https://images.contentstack.io/v3/download?crop=300,400. There are several more parameters that you can use for your images. 

[Read Image Delivery API documentation](https://www.contentstack.com/docs/apis/image-delivery-api/). 


## **Using the Sync API with Ruby SDK**

The Sync API takes care of syncing your Contentstack data with your app and ensures that the data is always up-to-date by providing delta updates. Contentstack’s Ruby SDK supports Sync API, which you can use to build powerful apps. Read through to understand how to use the Sync API with Contentstack Ruby SDK.
[Read Sync API documentation](https://www.contentstack.com/docs/platforms/ruby#using-the-sync-api-with-ruby-sdk).

### Initial sync

The Initial Sync process performs a complete sync of your app data. It returns all the published entries and assets of the specified stack in response.

To start the Initial Sync process, use the syncStack method.

```ruby
@sync_result = @stack.sync({init: true})
# @sync_result.items: contains sync data
# @sync_result.pagination_token: for fetching the next batch of entries using pagination token
# @sync_result.sync_token: for performing subsequent sync after initial sync
```

The response also contains a sync token, which you need to store, since this token is used to get subsequent delta updates later, as shown in the Subsequent Sync section below.

You can also fetch custom results in initial sync by using advanced sync queries.

### Sync pagination

If the result of the initial sync (or subsequent sync) contains more than 100 records, the response would be paginated. It provides pagination token in the response. You will need to use this token to get the next batch of data.

```ruby 
@sync_result = @stack.sync({pagination_token : "<pagination_token>"})
# @sync_result.items: contains sync data
# @sync_result.pagination_token: For fetching the next batch of entries using pagination token
# @sync_result.sync_token: For performing subsequent sync after initial sync
```

### Subsequent sync

You can use the sync token (that you receive after initial sync) to get the updated content next time. The sync token fetches only the content that was added after your last sync, and the details of the content that was deleted or updated.

```ruby
@sync_result = @stack.sync({sync_token : "<sync_token>"})
# @sync_result.items: contains sync data
# @sync_result.pagination_token: For fetching the next batch of entries using pagination token
# @sync_result.sync_token: For performing subsequent sync after initial sync
```

### Advanced sync queries

You can use advanced sync queries to fetch custom results while performing initial sync. 
[Read advanced sync queries documentation](https://www.contentstack.com/docs/guide/synchronization/using-the-sync-api-with-ruby-sdk#advanced-sync-queries)


```ruby
@sync_result = @stack.sync({init : true, locale: "<locale>" content_type_uid: "<content_type_uid>"})
# @sync_result.items: contains sync data
# @sync_result.pagination_token: For fetching the next batch of entries using pagination token
# @sync_result.sync_token: For performing subsequent sync after initial sync
```
## **Helpful Links**

* [Contentstack Website](https://www.contentstack.com)

* [Official Documentation](http://contentstack.com/docs)

* [Content Delivery API Docs](https://contentstack.com/docs/apis/content-delivery-api/)

## **The MIT License (MIT)**

Copyright © 2012-2021 [Contentstack](https://www.contentstack.com). All Rights Reserved

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

