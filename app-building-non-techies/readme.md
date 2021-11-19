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

gsheets -> xlsx -> xml -> upload -> data entry & recalculating -> submit -> sync -> JSON

---

## `cht-conf`

Command line utility:
* configure, upgrade and update CHT
* data and server software 

---

## `cht-conf` 

Push updated "MRDT" form:

```shell
cht \
  --url=http://admin:pass@localhost:5988 \
  fetch-forms-from-google-drive \
  convert-app-forms \
  upload-app-forms \
  -- test_form
```

---

## `cht-conf` example: push updated "MRDT" form

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

## gsheets

Easy Sharing and Revisions vs GitHub

![GSheets Sample](./gsheets.sample.png)

---

##  gsheets

`fetch-forms-from-google-drive`

Copy from GDrive -> local .xlsx

App builders start with an existing gsheet

---

## edit synched forms 
 
`forms-on-google-drive.json` JSON config file:

    
 ```json
{
    "app/test_form.xlsx": "1OX87YC6kAOvBgttjUhBL6fMdFSk",
    "app/results.xlsx": "YC6kAOvBgttjUhBL6fMdFSkd3dksfjks",
}
``` 

---

## Errors on CLI 
 
One extra "`,`" in `forms-on-google-drive.json` JSON config file:

```shell
INFO Processing config in covid-19. 
INFO Actions:
     - fetch-forms-from-google-drive
     - convert-app-forms
     - upload-app-forms 
INFO Starting action: fetch-forms-from-google-drive… 
WARN Error parsing JSON in: /home/mrjones/Documents/MedicMobile/cht-core/config/covid-19/forms-on-google-drive.json 
ERROR SyntaxError: Unexpected token } in JSON at position 168
    at JSON.parse (<anonymous>)
    at Object.readJson (/usr/lib/node_modules/cht-conf/src/lib/sync-fs.js:29:17)
    at /usr/lib/node_modules/cht-conf/src/lib/fetch-files-from-google-drive.js:12:24
    at processTicksAndRejections (internal/process/task_queues.js:97:5) 
``` 

---

## `cht-conf` first run

test export to local file:

```shell
cht --url=http://admin:pass@localhost:5988 fetch-forms-from-google-drive 
```

note that `cht-conf` allows you to string together multiple commands

---

## export -> convert ->  upload

Let's import our new one by adding convert-app-forms (xlsx -> xml) and upload-app-forms (xml -> CHT):

```shell
cht --url=http://admin:pass@localhost:5988 fetch-forms-from-google-drive convert-app-forms upload-app-forms -- test_form
```

see if it's there!

1. http://localhost:5988/#/reports/
1. submit report: Test Form

---

## Form properties json

Before we start form building, let's set some properties via the `forms/app/test_form.properties.json`:

    {
        "title": "Test Form",
        "icon": "draft-icon",
        "context": {
            "person": true,
            "place": false,
            "expression": "contact.type === 'person' && summary.alive && (!contact.date_of_birth ||  ageInYears(contact) < 5)"
        }
    }

---

## Go faster `cht-conf`

Add `upload-resources` to the `cht` to send the json as well:

```shell
cht --url=http://admin:pass@localhost:5988 fetch-forms-from-google-drive upload-resources convert-app-forms upload-app-forms -- test_form
```

---

## Updated properties

Back on your server, form is no longer available anywhere but on patients who are <= 5

http://localhost:5988/#/reports/

---

## xforms structure

* Inputs
* Top level calculation fields
* Pages of questions
* Summary page
* Data outputs

---

## Your 1st line of xform code

Let's add some questions! 

Below "Top level calculation fields", add a bunch of 
blank lines and copy the first note
    
```
note	register_note	Welcome to my first form
```
[source](https://github.com/mrjones-plip/mrjones-medic-scratch/tree/main/app-building#your-1st-line-of-xform-code)

---

## Rinse and repeat

re-run our fave cht command (you could trim off "upload-resources")

```shell
cht --url=http://admin:pass@localhost:5988 fetch-forms-from-google-drive upload-resources convert-app-forms upload-app-forms -- test_form
```

---

## reload reload reload 

reload the form in the browser and you should see your note

you are now an app builder!

Note : fastest to cancel and start again vs reload

---

## Now with 100% more dates

let's add a date input after the note

```text
date	fave_past_date	What's your fave past date?
```
[source](https://github.com/mrjones-plip/mrjones-medic-scratch/tree/main/app-building#now-with-100-more-dates)

---

## Rinse and repeat & reload reload reload 

re-run our fave cht command & reload the browser. note it's on page two of form

```shell
cht --url=http://admin:pass@localhost:5988 fetch-forms-from-google-drive upload-resources convert-app-forms upload-app-forms -- test_form
```
---

## field-list 

let's put the two on one page
   
```text
begin group	hello_world	Hello World App!									field-list
note	welcome_note	Welcome to my first form									
date	fave_past_date	What's your fave past date?									
end group	
```

---

## constraints

Let's ask  them about past dates by adding this to constraints:

```text
decimal-date-time(.) < floor(decimal-date-time(today()))
```

---

## Rinse and repeat & reload reload reload

re-run our fave cht command & reload the browser. note it's on page two of form

```shell
cht --url=http://admin:pass@localhost:5988 fetch-forms-from-google-drive upload-resources convert-app-forms upload-app-forms -- test_form
```

---

## select one

let's only show the date if they like old dates. add this above the date row:

```text
select_one yes_no	old_dates	Do you like old dates?
```

Note values in "choices" tab

---

## relevant

and now, add this to "relevant" column for the date input:


```text
selected(${old_dates}, 'yes')
```

Tell the user how to fix bad data! In "constraint_message::en" field, add:

```text
The date must be in the past.
```

---

## Rinse and repeat & reload reload reload

re-run our fave cht command & reload the browser. note it's on page two of form

```shell
cht --url=http://admin:pass@localhost:5988 fetch-forms-from-google-drive upload-resources convert-app-forms upload-app-forms -- test_form
```

---

## calculate 

finally, let's calculate something! 100 years after the date.  Add a row in the above "calculate" section:

    calculate	hundred_years	NO_LABEL																		format-date-time(date-time(floor(decimal-date-time(${fave_past_date})) + 36525), "%Y-%m-%d")															

And then add this as the last row in your group:

---

## Completed form

```text
begin group	hello_world	Hello World App!									field-list		
note	welcome_note	Welcome to my first form											
select_one yes_no	old_dates	Do you like old dates?											
date	fave_past_date	What's your fave past date?								selected(${old_dates}, 'yes')		decimal-date-time(.) < floor(decimal-date-time(today()))	The date must be in the past.
note	hundred_note	This is the date in 100 years from your date: ${hundred_years}								decimal-date-time(${fave_past_date}) < floor(decimal-date-time(today()))			
end group
```

---

## Rinse and repeat & reload reload reload 

re-run our fave cht command & reload the browser. note it's on page two of form

```shell
cht --url=http://admin:pass@localhost:5988 fetch-forms-from-google-drive upload-resources convert-app-forms upload-app-forms -- test_form
```

a fitting end - you do this SO. MANY. TIMES. ;)

---

## Next time

* [Tasks](https://docs.communityhealthtoolkit.org/apps/reference/tasks/)
* [Targets](https://docs.communityhealthtoolkit.org/apps/reference/targets/)

---

## Thanks!

* By: [mrjones](https://github.com/mrjones-plip)
* Source: [app-building repo](https://github.com/mrjones-plip/mrjones-medic-scratch/tree/main/app-building)
* Made: [reveal-md](https://github.com/webpro/reveal-md)

[![medic logo](./medic-mobile-logo+name-white.svg)](https://medicmobile.org)