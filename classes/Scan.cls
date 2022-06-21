public class Scan {

    public String id {get; set;}
    public String status {get; set;}
    public String result {get; set;}
    public String status_check {get; set;}
    public String html_url {get; set;}
    public String sarif_url {get; set;}
    public List<ScanPolicy> scan_policies {get; set;}
    
}