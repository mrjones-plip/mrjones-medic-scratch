# App Building for Techies

Notes on leading a crash course for engineering types on how to build an app

## Overview

gsheets -> xlsx -> xml -> uploaded -> data entry & recalculating -> submit -> sync-> JSON

## References

https://github.com/medic/cht-docs/issues/386
https://xlsform.org/en/


## Prereqs 

(tested on ubuntu 16.04)

install couch:
 
    apt-get install couchdb=2.3.1~xenial -V

install node

    curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
    sudo apt-get install nodejs

Install grunt-cli

    sudo apt-get install nodejs

install xsltproc

    apt install xsltproc

clone cht repo and install

    git clone https://github.com/medic/cht-core
    cd cht-core
    npm ci

configure couchdb: http://localhost:5988/_utils/

harden couchdb

    curl -X PUT "http://admin:pass@localhost:5984/_node/$COUCH_NODE_NAME/_config/httpd/WWW-Authenticate"  -d '"Basic realm=\"administrator\""' -H "Content-Type: application/json"

Install medic-conf

    sudo apt install python-pip
    sudo python -m pip install git+https://github.com/medic/pyxform.git@medic-conf-1.17#egg=pyxform-medic

set EXPORTS

    export COUCH_NODE_NAME=couchdb@127.0.0.1&&export COUCH_URL=http://admin:pass@localhost:5984/medic
    
start cht (3 diff terminals)

    grunt
    cd api&&node server.js
    cd sentinel&& node server.js

ensure it's up http://localhost:5988

# Course

set up login if needed
    * create a new area w/ a contact
    * create a user w/ the new contact: chw/331Medic

get magic ".gdrive.secrets.json" json file in 1pass, put it in config/default

in google docs, copy this sheet to a new file called test_form:
    https://docs.google.com/spreadsheets/d/1EWwkyhhle05fHj5hoKlNgABNKOrgp30BFZrbpYT1AHU

go to settings worksheet tab and change:
     form title: Test form
     formid: test_form

edit forms-on-google-drive.json to only have your new form

    
    {
    "app/test_form.xlsx": "1OX87YC6kAOvlC1axQs_PRXR4hABBgttjUhBL6fMdFSk"
    } 
    

test export to local file:

    medic-conf --url=http://admin:pass@localhost:5988 fetch-forms-from-google-drive 

note that medic-conf allows you to string together multiple commands

let's import our new one by adding convert-app-forms (xlsx -> xml) and upload-app-forms:
    medic-conf --url=http://admin:pass@localhost:5988 fetch-forms-from-google-drive convert-app-forms upload-app-forms -- test_form

see if it's there!
    1. http://localhost:5988/#/reports/
    1. submit report: Test Form

before we start editing the form, let's update some properties. create a forms/app/test_form.properties.json file with the following:

    {
    "title": "Test Form",
    "icon": "draft-icon",
    "context": {
        "person": true,
        "place": false,
        "expression": "contact.type === 'person' && summary.alive && (!contact.date_of_birth ||  ageInYears(contact) < 5)"
    }
    }
    
now let's add a "upload-resources" to the medic-conf to send this as well:

    medic-conf --url=http://admin:pass@localhost:5988 fetch-forms-from-google-drive upload-resources convert-app-forms upload-app-forms -- test_form

back on your server, form is no longer available anywhere but on patients <5

review xforms structure:
    * Inputs
    * Top level calculation fields
    * Pages of questions
    * Summary page
    * Data outputs

Let's add some questions! below "Top level calculation fields" , add a bunch of blank lines and copy the first note:
    note	register_note	Welcome to my first form

re-run our fave medic-conf command (you could trim off "upload-resources")

reload the form and you should see your note

you are now an app builder!

let's add a date input after the note
    date	how_old	What's your fave date?

re-run our fave medic-conf command & reload the browser. note it's on page too

let's put the two on one page
    
    begin group	hello_world	Hello World App!									field-list
    note	welcome_note	Welcome to my first form									
    date	how_old	What's your fave date?									
    end group	
    

Let's ask  them about past dates by adding this to constraints:
    decimal-date-time(.) < floor(decimal-date-time(today()))

let's only show the date if they like old dates. add this above the date row:
    select_one yes_no	old_dates	Do you like old dates?

and now, add this to "relevant" column for the date input:
    selected(${old_dates}, 'yes')

finally, let's calculate something! 100 years after the date.  Add a row in the above "calculate" section:

    calculate	hundred_years	NO_LABEL																		format-date-time(date-time(floor(decimal-date-time(${how_old})) + 36525), "%Y-%m-%d")															
    And then add this as the last row in your group:
    note	hundred_note	This is the date in 100 years from your date: ${hundred_years}								decimal-date-time(${how_old}) < floor(decimal-date-time(today()))
    