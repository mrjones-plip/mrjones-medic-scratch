---
title: App Building for Techies
revealOptions:
    transition: 'none'
---

# App Building for Techies

A crash course for engineering folks on how to build a [CHT](https://communityhealthtoolkit.org/) app

[mrjones](https://github.com/mrjones-plip)
  
[this preso on GH](https://github.com/mrjones-plip/mrjones-medic-scratch/tree/main/app-building)

[![medic logo](./medic-mobile-logo+name-white.svg)](https://medicmobile.org)

---

## Overview

Use `medic-conf` and the browser to:

gsheets -> xlsx -> xml -> upload -> data entry & recalculating -> submit -> sync -> JSON


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

## Prerequisites 1

[CHT Core development environment](https://github.com/medic/cht-core/blob/master/DEVELOPMENT.md) 
 
OR

[CHT Docker Compose Helper](https://github.com/medic/cht-core/blob/master/scripts/docker-helper)

---

## Prerequisites 2

Clone CHT Core & this preso's repos:

```shell
git clone https://github.com/mrjones-plip/mrjones-medic-scratch.git
git clone https://github.com/medic/cht-core
```

* Core: default config as template
* This repo: copying/pasting snippets

---
## Prerequisites 3

`cht-conf` (formerly `medic-conf`)

```shell
npm install -g cht-conf
sudo python -m pip install git+https://github.com/medic/pyxform.git@medic-conf-1.17#egg=pyxform-medic
```

See [GH Site](https://github.com/medic/cht-conf)

---

## set up CHT web login if needed

* create a new Facility with a contact
* associate your admin user the new contact

(note diff between admin users, offline users)

---

## get magic perms file
 
`.gdrive.secrets.json` json file in 1password, put it in `config/default`

---

## create your gsheets files

Copy this sheet to a new file called test_form:

https://docs.google.com/spreadsheets/d/1EWwkyhhle05fHj5hoKlNgABNKOrgp30BFZrbpYT1AHU

go to settings worksheet tab and change:

* form title: Test form
* formid: test_form

---

## edit synched forms 
 
Edit `forms-on-google-drive.json` only have your new form:
    
 ```json
{"app/test_form.xlsx": "1OX87YC6kAOvlC1axQs_PRXR4hABBgttjUhBL6fMdFSk"}
``` 

Replace your ID from prior step

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