public class ScanPolicy {

    @AuraEnabled 
    public String id {get; set;}
    @AuraEnabled 
    public String title {get; set;}
    @AuraEnabled 
    public String html_url {get; set;}
    @AuraEnabled 
    public String sarif_url {get; set;}
    @AuraEnabled 
    public String result {get; set;}
    @AuraEnabled 
    public String status_check {get; set;}

}