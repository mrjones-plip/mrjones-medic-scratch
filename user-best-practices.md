response to [forum post](https://forum.communityhealthtoolkit.org/t/best-practices-for-user-management-at-scale/1668)

--------

I've had a number of conversations about this over the past few weeks and I wanted to report back to the community about what I've found.  

## How does the CHT recommend retiring users and replacing them with new ones?

I found a number of real world practices that I wanted to spell out the pros and cons of. Let's start with

### New contact & new user, associate with existing place

This is top most recommended practice.  The steps are:

1. Have the old CHW do one last sync to ensure all data is pushed up from their device
1. Create a new contact for the new CHW.
1. Make this contact the new primary contact for the old CHW's place - do not create a new place!
1. Change the name the CHW's place as needed
1. Create a new user  associated to the new contact.
1. Change the password for the old CHW's user.

#### Pros
* No data loss from one CHW to another
* Humans and computers alike looking at the CHT, CouchDB and Posgtress can tell both who was giving the care, and when the switch happened between caregivers.
* Households associated with the old CHWs place do not need to be re-parented.
* All reports from the old CHW are accessible to the new CHW.
* Any replication and applicable replication depth rules apply exactly the same as before - no more or less data will be synchronized
* Very secure - old CHW can not log in

#### Cons
* Old CHW Contacts linger around, which may pollute workflows. There is no native "disabled" flag for a contact.


### Edit existing contact,  user and  place

This is straightforward and a single step: just change the name on the 3 records.  This practice is not recommended, but offers a lot of real world benefits.

#### Pros
* Very few steps to set up
* No extra CHW user and contact left to linger

#### Cons
* Humans and computers alike looking at the CHT, CouchDB and Posgtress can **NOT** tell both who was giving the care, and when the switch happened between caregivers.
* If the old CHW returns and you want to keep both CHWs active, you're stuck creating a new contact and user.
* Insecure - the old CHW can still log in on another device

### Handing the mobile phone from one CHW to another

This is by far the simplest practice - effectively no steps are needed in the CHT.  It comes with many draw backs and is not recommended. The pros and cons are similar to prior option.

#### Pros
* No setup
* No extra CHW user and contact left to linger

#### Cons
* Humans and computers alike looking at the CHT, CouchDB and Posgtress can **NOT** tell both who was giving the care, and when the switch happened between caregivers.
* If the old CHW returns and you want to keep both CHWs active, you're stuck creating a new contact and user AND getting a new device.
* Insecure - the old CHW can still log in on another device
