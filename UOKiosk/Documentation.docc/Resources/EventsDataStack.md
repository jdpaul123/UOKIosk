# EventsDataStack

Outlining how the data on events is loaded into the system and chached.

## Overview

On initial boot up of the application:
1. the events are uploaded to the application via a url session call to the web API for the events data.
2. The data is decoded to a data transfer object (DTO).
3. The DTO is then transformed into the model data.
4. The model data is saved to Core Data and the date that the data is being saved to core data is saved too.
5. The model data is turned into the view model for the events list view.
6. The model data is sent to the detail views to create the view model for the event detail view.

On second boot up the same day.
1. Core data loads in the events data.
2. The date of last load is checked to be the same day so data is not updated.

On boot up the next day.
1. Core data loads in the events data.
2. The date of last load is checked to not be the current day (it is the day before now)
3. The api is called to update the data
4. Once the data is loaded from the api, any event that was timestamped to be loaded at a time before nwo is
   deleted and the new data is set.

On pull down events page update.
1. The api is called to get the current events.
2. Only once the new events are loaded in, the old events timestamped as being loaded before now are deleted
   and the new data is set

## Topics

### <!--@START_MENU_TOKEN@-->Group<!--@END_MENU_TOKEN@-->

- <!--@START_MENU_TOKEN@-->``Symbol``<!--@END_MENU_TOKEN@-->
