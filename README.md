
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

    # with default region
    client = Contentstack::Client.new("site_api_key", "access_token", "enviroment_name")
    
    # with specific region
    client = Contentstack::Client.new("site_api_key", "access_token", "enviroment_name",{"region": Contentstack::Region::EU})
    
    # with custom host
    client = Contentstack::Client.new("site_api_key", "access_token", "enviroment_name",{"host": "https://custom-cdn.contentstack.com"})




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

### **Initializing your SDK **

To initialize the SDK, you need to provide values for the keys given in the snippet below:

    stack = Contentstack::Client.new("site_api_key", "access_token", "enviroment_name")

To get the API credentials mentioned above, log in to your Contentstack account and then in your top panel navigation, go to Settings > Stack to view the API Key and Access Token.

### **Querying content from your stack**

To fetch all entries of of a content type, use the query given below:

    entry = stack.content_type(<<CONTENT_TYPE_UID>>).query();

To fetch a specific entry from a content type, use the following query:

    entry = stack.content_type(<<CONTENT_TYPE_UID>>).entry(<<ENTRY_UID>>);

## **Advanced Queries**

You can query for content types, entries, assets and more using our Ruby API Reference. 

[Ruby API Reference Doc](http://www.rubydoc.info/gems/contentstack)

## **Working with Images**

We have introduced Image Delivery APIs that let you retrieve images and then manipulate and optimize them for your digital properties. It lets you perform a host of other actions such as crop, trim, resize, rotate, overlay, and so on. 

For example, if you want to crop an image (with width as 300 and height as 400), you simply need to append query parameters at the end of the image URL, such as, https://images.contentstack.io/v3/assets/blteae40eb499811073/bltc5064f36b5855343/59e0c41ac0eddd140d5a8e3e/download?crop=300,400. There are several more parameters that you can use for your images. 

[Read Image Delivery API documentation](https://www.contentstack.com/docs/apis/image-delivery-api/). 

SDK functions for Image Delivery API coming soon. 

## **Helpful Links**

* [Contentstack Website](https://www.contentstack.com)

* [Official Documentation](http://contentstack.com/docs)

* [Content Delivery API Docs](https://contentstack.com/docs/apis/content-delivery-api/)

## **The MIT License (MIT)**

Copyright © 2012-2020 [Contentstack](https://www.contentstack.com). All Rights Reserved

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

