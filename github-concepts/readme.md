---
title: Github and git concepts
revealOptions:
    transition: 'none'
---

# Github and git concepts
 

[mrjones @ github](https://github.com/mrjones-plip)

[presentation source @ github](https://github.com/mrjones-plip/mrjones-medic-scratch/tree/main/github-howto)

[![medic logo](./medic-mobile-logo+name-white.svg)](https://medicmobile.org)

---

## What does this it all mean?

github vs git? clone? commit? branch? PR? Outside changes?

![branch life](./mnch.branch.png)

---

## Github vs git

* Github: web interface to git (+ special sauce)
* git: used to track revisions in code, works on text, images etc

---

## clone

* copies a repository remote server -> your computer 
* is *complete* copy of *every* change, *ever*
* changes made (aka in your clone) only exist locally until you `commit` and `push` them


---

## commit

* changes are recorded to your clone when you `commit` them
* shared changes by `push`ing your commits back to where you cloned from 
* any changes you make can be reverted at any time
* any changes you do not `push` can not be seen by others

---

## branch

* branches normally capture a logical chunk of work (ie a ticket)
* branches normally have a ticket in their name: `6724-MNCH-docs`
* all branches exist locally, both `master` and any new ones like `6724-MNCH-docs`
* allows others to view your work (and even add commits!)


---

## pull request

* explicitly created to get feedback on a request to merge changes to `master`
* allow you to view and comment on a series of commits. 
* not part of git, provided by Github
* other users can comment and request changes in a PR
* multiple commits may be added over time to address feedback

---

## upstream changes

* changes to master
* changes on your branch 

---

## life of a branch

![branch life](./branch.life.png)

[see github docs](https://guides.github.com/introduction/flow/)


---

## MNCH Docs branch

![branch life](./mnch.branch.png)

[see MNCH network graph](https://github.com/medic/cht-docs/network)


---

## Thanks!

* By: [mrjones](https://github.com/mrjones-plip)
* Source: [app-building repo](https://github.com/mrjones-plip/mrjones-medic-scratch/tree/main/github-howto)
* Made: [reveal-md](https://github.com/webpro/reveal-md)

[![medic logo](./medic-mobile-logo+name-white.svg)](https://medicmobile.org)