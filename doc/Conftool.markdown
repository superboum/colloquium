Conftool
========

Overview
--------

Conftool is a tool to organize a conference. It has three main functionnalities : 

* The submission and review process of contributions
* The scheduling of the conference program
* The registration administration and invoicing of participants

Two versions
------------

###VSIS Conftool

It was designed for small events, more or less limited to __150 participants__. It's not open source and is available __only on demand__. It's limited to __small and non-commercial__ events. It's self hosted, and without support.

__Price : More ore less free__

###ConfTool Pro

ConfTool Pro doesn't have any limit. It's hosted on conftool server. They provide a support.


__Price : Not free, on demand__

Conftool Pro main features
----------------------

 * Hosted software solution with support
 * Customizable submission and review forms
 * Scheduling of the conference program
 * Enhanced export options
 * Invitation option for authors, reviewers, and program committee members
 * Payment options

VSIS Conftool Technical informations
------------------------------------

Conftool uses PHP & MySQL. Recommended configuration is :

```
Apache 2.0 or higher
PHP Version 5.3 (PHP should run as Apache module. The PHP modules php_mysql, curl and mbstring are required).
MySQL Version 5.1 or later.
Your server should also run (or have access to) an smtp (e-mail) and a DNS server.
```

Why VSIS Conftool doesn't meet our requirements
-----------------------------------------------

1. Registration pages can't be customized. Impossible to add our own fields, own colors, own template. 
2. Passwords are stored in plain text. This is a __serious__ security issue. Moreover, they should be hashed & salted and not encrypted.  
3. Email are not validated.
4. Can't export data, can't search in database
5. Less professionnal, conftool is a third party product which always display his brand and will never exactly fit our website.
6. All other functionnalities are limited in the free version 

To conclude, ConfTool is a turnkey product. Our project should not integrate ConfTool, because it is locked and already complete. Conftool est a tool to organize a conference without any computer knowledge.
