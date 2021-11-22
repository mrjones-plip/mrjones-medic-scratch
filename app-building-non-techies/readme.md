---
title: App Building for Techies
revealOptions:
    transition: 'none'
---

# App Building for Non-Techies

Step by step how app builders make a [CHT](https://communityhealthtoolkit.org/) app

[mrjones](https://github.com/mrjones-plip)
  
[this preso on GH](https://github.com/mrjones-plip/mrjones-medic-scratch/tree/main/app-building-non-techies)

[![medic logo](./medic-mobile-logo+name-white.svg)](https://medicmobile.org)

---

## References

* CHT Docs
  * [App forms tutorial](https://docs.communityhealthtoolkit.org/apps/tutorials/app-forms) 
  * [Forms Reference](https://docs.communityhealthtoolkit.org/apps/reference/forms/app/)
* [Docs Cheat Sheet PR](https://github.com/medic/cht-docs/issues/386)
* Capacity Building:
  * [Modules List](https://docs.google.com/document/d/1E_GEAMk8LwmopGxPg6r5ipOk4-4vi5_A_oUaNd_3afs/edit)
  * [App Forms Module](https://docs.google.com/document/d/1b-3TIOwfPYjZ5Bb0ybDeBk9S584D1IbvcnsYcTehLfs/edit) (-> App forms tutorial)   
* [xls form reference site](https://xlsform.org/en/)

---

## Overview

Use `cht-conf` and the browser to:

Google Sheets -> xlsx -> xml -> upload -> data entry & recalculating -> submit -> sync -> JSON

---

## `cht-conf`

Command line utility:
* configure, upgrade and update CHT
* data and server software 

---

## `cht-conf` 

Example: Update "test_form" form:

```shell
cht \
  --url=http://admin:pass@localhost:5988 \
  fetch-forms-from-google-drive \
  convert-app-forms \
  upload-app-forms \
  -- test_form
```

---

## `cht-conf`

Example: Result from "test_form" form:

```shell
INFO Processing config in covid-19. 
INFO Actions:
     - fetch-forms-from-google-drive
     - convert-app-forms
     - upload-app-forms 
INFO Starting action: fetch-forms-from-google-drive… 
INFO Exporting 1eXQ-j_tf0RxukgW5yMjnAadtoOu_Lt_mlveWxDW6K00 from google drive to /home/mrjones/Documents/MedicMobile/cht-core/config/covid-19/forms/app/covid19_rdt_capture.xlsx… 
INFO Successfully wrote /home/mrjones/Documents/MedicMobile/cht-core/config/covid-19/forms/app/covid19_rdt_capture.xlsx. 
INFO Exporting 1pDNi-CVLKJCdVjYY8UxHkDCbjTKeVBwCgg9hKRWQoqY from google drive to /home/mrjones/Documents/MedicMobile/cht-core/config/covid-19/forms/app/covid19_rdt_provision.xlsx… 
INFO Successfully wrote /home/mrjones/Documents/MedicMobile/cht-core/config/covid-19/forms/app/covid19_rdt_provision.xlsx. 
INFO fetch-forms-from-google-drive complete. 
INFO Starting action: convert-app-forms… 
WARN No matches found for files matching form filter: test_form.xlsx 
INFO convert-app-forms complete. 
INFO Starting action: upload-app-forms… 
WARN No matches found for files matching form filter: test_form.xml 
WARN No matches found for files matching form filter: test_form.xml 
INFO upload-app-forms complete. 
INFO All actions completed.
```

---

## Google Sheets

Easy Sharing and Revisions vs GitHub

![Google Sheets Sample](./images/gsheets.sample.png)

---

##  Google Sheets

`fetch-forms-from-google-drive`

Copy from Google Drive -> local .xlsx

App builders start by copying a gsheet - this talk will use `test_form`

---

## edit synched forms 
 
`forms-on-google-drive.json` JSON config file:
    
 ```json
{
    "app/test_form.xlsx": "1OX87YC6kAOvBgttjUhBL6fMdFSk",
}
``` 

---

## `cht-conf` first run

test export to local file:

```shell
cht --url=http://admin:pass@localhost:5988 \
  fetch-forms-from-google-drive 
```

note that `cht-conf` allows you to string together multiple commands

---

## Errors on CLI 

Bad "`,`" in config file:

<pre class="hljs">
$ cht fetch-forms-from-google-drive

INFO Processing config in default. 
INFO Actions:
     - fetch-forms-from-google-drive 
INFO Starting action: fetch-forms-from-google-drive… 
WARN Error parsing JSON in: /home/mrjones/Documents/MedicMobile/cht-core/config/default/forms-on-google-drive.json
<span style="color:red">ERROR SyntaxError: Unexpected token } in JSON at position 74
    at JSON.parse (<anonymous>)
    at Object.readJson (/usr/lib/node_modules/cht-conf/src/lib/sync-fs.js:29:17)
    at /usr/lib/node_modules/cht-conf/src/lib/fetch-files-from-google-drive.js:12:24
    at processTicksAndRejections (internal/process/task_queues.js:97:5)
</span></pre>

---

## export -> convert ->  upload

Let's import our new `test_form` by adding convert-app-forms (xlsx -> xml) and upload-app-forms (xml -> CHT):

```shell
cht --url=http://admin:pass@localhost:5988 \
  fetch-forms-from-google-drive \
  convert-app-forms upload-app-forms \
  -- test_form
```

---

## export -> convert ->  upload

see if it's there!

1. http://localhost:5988/#/reports/
2. Submit report
3. Test Form


![Test Form Test](./images/test.form.test.png)

---

## Form properties json

Before we start form building, let's set some properties via the `forms/app/test_form.properties.json`:

```json
{ "title": "Test Form",
"icon": "icon-person",
"context": {
    "person": true,
    "place": false,
    "expression": "contact.type === 'person' && summary.alive && (!contact.date_of_birth ||  ageInYears(contact) < 5)"
}}
```
---

## Go faster `cht-conf`

Add `upload-resources` to the `cht` to send the json as well:

```shell
cht --url=http://admin:pass@localhost:5988 \
  fetch-forms-from-google-drive \
  upload-resources \
  convert-app-forms \
  upload-app-forms \
  -- test_form
```

---

## Updated properties

Back on your server, form is no longer available anywhere but on patients who are <= 5

http://localhost:5988/#/reports/

![Test Form New Home](./images/now.test.form.home.png)

---

## xforms structure

Inputs - Calculated - Questions - Summary - Outputs

![Anatomy](./images/anotomy.png)

---

## Your 1st line of xform code

Let's add some questions! 

Below "Top level calculation fields", add a bunch of 
blank lines and copy the first note

![First Note](./images/first.note.png)

---

## Rinse and repeat

re-run our fave cht command (you could trim off "upload-resources")


```shell
cht --url=http://admin:pass@localhost:5988 \
  fetch-forms-from-google-drive \
  upload-resources \
  convert-app-forms \
  upload-app-forms \
  -- test_form
```

---

## reload 

reload the form in the browser and you should see your note

![First Screen](./images/first.appscreen.png)


---

## Now with 100% more dates

let's add a date input after the note

![Second Input](./images/2nd.screen.png)


---

## Rinse and repeat 

re-run our fave `cht` command

```shell
cht --url=http://admin:pass@localhost:5988 \
  fetch-forms-from-google-drive \
  upload-resources \
  convert-app-forms \
  upload-app-forms \
  -- test_form
```

---

##  reload 

Reload the browser & note it's on two seperate pages:

![Second Screen](./images/2nd.screen.app.png)


---

## field-list 

Let's put the two on one page & and ensure only past dates via a constraints:

![Grouped](./images/grouped.with.constraint.png)

```
decimal-date-time(.) < floor(decimal-date-time(today()))
```

---

## Rinse and repeat 

re-run our fave `cht` command 

```shell
cht --url=http://admin:pass@localhost:5988 \
  fetch-forms-from-google-drive \
  upload-resources \
  convert-app-forms \
  upload-app-forms \
  -- test_form
```

---

## reload

Note it's on one page and there's a constraint:

![Grouped and constrained](./images/grouped.with.constraint2.png)

---

## calculate 

Finally, let's ask if they like old dates and calculate 100 years later:

![Final sheets edit](./images/final.edit.png)

```
format-date-time(
    date-time(
        floor(
            decimal-date-time(
                ${fave_past_date})) + 36525), "%Y-%m-%d")
```

---

## Rinse and repeat 

re-run our fave `cht` command

```shell
cht --url=http://admin:pass@localhost:5988 \
  fetch-forms-from-google-drive \
  upload-resources \
  convert-app-forms \
  upload-app-forms \
  -- test_form
```

a fitting end - you do this SO. MANY. TIMES. ;)
---

## Our first app completed


![Final App](./images/all.together.now.png)

---

## Thanks!

* By: [mrjones](https://github.com/mrjones-plip)
* Source: [app-building-non-techies repo](https://github.com/mrjones-plip/mrjones-medic-scratch/tree/main/app-building-non-techies)
* Made: [reveal-md](https://github.com/webpro/reveal-md)

[![medic logo](./medic-mobile-logo+name-white.svg)](https://medicmobile.org)