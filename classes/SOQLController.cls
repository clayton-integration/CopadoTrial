public with sharing class SOQLController {
    public SOQLController() {

    }


    @AuraEnabled
    public static String getCandidateGrade(String contactId) { 
        
        // Build the query
        String selectQueryString = 'SELECT Name, Salary__c, NextAvailableDate__c FROM Contact where Id = \'' + contactId + '\'';
        Contact currentContact = Database.query(selectQueryString);
        
       return 'OK';
    }
}