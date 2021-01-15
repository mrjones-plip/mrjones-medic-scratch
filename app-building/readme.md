---
title: App Building for Techies
revealOptions:
    transition: 'none'
---

# App Building for Techies

A crash course for engineering folks on how to build a [CHT](https://communityhealthtoolkit.org/) app

* By: [mrjones](https://github.com/mrjones-plip)
* Source: [app-building repo](https://github.com/mrjones-plip/mrjones-medic-scratch/tree/main/app-building)
* Made: [reveal-md](https://github.com/webpro/reveal-md)

---

## Overview

Use `medic-conf` and the browser to:

gsheets -> xlsx -> xml -> upload -> data entry & recalculating -> submit -> sync -> JSON


---

## References

* [CHT Docs: app forms](https://docs.communityhealthtoolkit.org/apps/tutorials/app-forms) 
* [CHT Docs: reference: forms](https://docs.communityhealthtoolkit.org/apps/reference/forms/app/)
* [CHT Docs: Cheat Sheet PR](https://github.com/medic/cht-docs/issues/386)
* [xls form reference site](https://xlsform.org/en/)


---

## Prerequisites 1

    // tested on Ubuntu 18.04
    // install couch (use )
    apt-get install couchdb=2.3.1~xenial -V
    // install node
    curl -sL https://deb.nodesource.com/setup_14.x| sudo -E bash -&&sudo apt-get install nodejs
    //Install grunt-cli
    sudo npm install -g grunt-cli
    // install xsltproc
    apt install xsltproc
    // clone cht repo and install
    git clone https://github.com/medic/cht-core&&cd cht-core&&npm ci
    //configure couchdb: http://localhost:5984/_utils/
    //set EXPORTS
    export COUCH_NODE_NAME=couchdb@127.0.0.1&&export COUCH_URL=http://admin:pass@localhost:5984/medic
    // harden couchdb & allow Fauxton access
    COUCH_URL=http://admin:pass@localhost:5984/medic COUCH_NODE_NAME=couchdb@127.0.0.1 grunt secure-couchdb
    curl -X PUT "http://admin:pass@localhost:5984/_node/$COUCH_NODE_NAME/_config/httpd/WWW-Authenticate"  -d '"Basic realm=\"administrator\""' -H "Content-Type: application/json"
    // Install medic-conf
    sudo apt install python-pip&&sudo python -m pip install git+https://github.com/medic/pyxform.git@medic-conf-1.17#egg=pyxform-medic
    // start cht (3 diff terminals)
    grunt
    cd api&&node server.js
    cd sentinel&& node server.js
    // ensure it's up http://localhost:5988

per  [CHTS development.md](https://github.com/medic/cht-core/blob/master/DEVELOPMENT.md)

---

## Prerequisites 2

Clone this repo:

    git clone https://github.com/mrjones-plip/mrjones-medic-scratch.git

---

## set up CHT web login if needed

* create a new area w/ a contact
* create a user w/ the new contact: chw/331Medic

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
    
    {"app/test_form.xlsx": "1OX87YC6kAOvlC1axQs_PRXR4hABBgttjUhBL6fMdFSk"} 
    
Replace your ID from prior step

---

## medic-conf first run

test export to local file:

    medic-conf --url=http://admin:pass@localhost:5988 fetch-forms-from-google-drive 

note that medic-conf allows you to string together multiple commands

---

## export -> convert ->  upload

Let's import our new one by adding convert-app-forms (xlsx -> xml) and upload-app-forms (xml -> CHT):

    medic-conf --url=http://admin:pass@localhost:5988 fetch-forms-from-google-drive convert-app-forms upload-app-forms -- test_form

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

## Go faster medic-conf

Add `upload-resources` to the `medic-conf` to send the json as well:

    medic-conf --url=http://admin:pass@localhost:5988 fetch-forms-from-google-drive upload-resources convert-app-forms upload-app-forms -- test_form

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

re-run our fave medic-conf command (you could trim off "upload-resources")

    medic-conf --url=http://admin:pass@localhost:5988 fetch-forms-from-google-drive upload-resources convert-app-forms upload-app-forms -- test_form

---

## reload reload reload 

reload the form in the browser and you should see your note

you are now an app builder!

Note : fastest to cancel and start again vs reload

---

## Now with 100% more dates

let's add a date input after the note

```
date	how_old	What's your fave date?
```
[source](https://github.com/mrjones-plip/mrjones-medic-scratch/tree/main/app-building#now-with-100-more-dates)

---

## Rinse and repeat & reload reload reload 

re-run our fave medic-conf command & reload the browser. note it's on page two of form

    medic-conf --url=http://admin:pass@localhost:5988 fetch-forms-from-google-drive upload-resources convert-app-forms upload-app-forms -- test_form

---

## field-list 

let's put the two on one page
   
    begin group	hello_world	Hello World App!									field-list
    note	welcome_note	Welcome to my first form									
    date	how_old	What's your fave date?									
    end group	


---

## constraints

Let's ask  them about past dates by adding this to constraints:

    decimal-date-time(.) < floor(decimal-date-time(today()))

---

## select one

let's only show the date if they like old dates. add this above the date row:

    select_one yes_no	old_dates	Do you like old dates?

Note values in choices tab

---

## relevant

and now, add this to "relevant" column for the date input:

    selected(${old_dates}, 'yes')

---

## calculate 

finally, let's calculate something! 100 years after the date.  Add a row in the above "calculate" section:

    calculate	hundred_years	NO_LABEL																		format-date-time(date-time(floor(decimal-date-time(${how_old})) + 36525), "%Y-%m-%d")															
    And then add this as the last row in your group:
    note	hundred_note	This is the date in 100 years from your date: ${hundred_years}								decimal-date-time(${how_old}) < floor(decimal-date-time(today()))


---

## Rinse and repeat & reload reload reload 

re-run our fave medic-conf command & reload the browser. note it's on page two of form

    medic-conf --url=http://admin:pass@localhost:5988 fetch-forms-from-google-drive upload-resources convert-app-forms upload-app-forms -- test_form

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
