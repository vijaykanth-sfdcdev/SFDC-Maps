import { LightningElement } from 'lwc';
import getAddressSet from '@salesforce/apex/demoGoogleMaps.getAddressSet';
import getDistance from '@salesforce/apex/demoGoogleMaps.getDistance';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class AddressPage extends LightningElement {
    isOrigin;
    searchOriginResults;
    searchDestinationResults;
    selectedSearchResult=[];
    distance;
    time;
    cost;
    value = '';
    showLoader=false;
    showNavFields=false;
    get options() {
        return [
            { label: 'Walking', value: 'walking' },
            { label: 'Driving', value: 'driving' },
           
        ];
    }
      selectSearchResult(event) {
        const selectedValue = event.currentTarget.dataset.value;
        var searchResults= this.searchOriginResults!=null ?this.searchOriginResults: this.searchDestinationResults;
        this.selectedSearchResult = searchResults.find(
          (picklistOption) => picklistOption.place_id === selectedValue
        );
        let showCommaWithsecondary_text=this.selectedSearchResult.secondary_text!=null?','+this.selectedSearchResult.secondary_text:'';
        let address=this.selectedSearchResult.main_text+showCommaWithsecondary_text;
        if(this.isOrigin){
            this.selectedOriginValue=address;
        }else{
            this.selectedDestinationValue=address;
        }
        
        
        this.clearSearchResults();
      }
    
      clearSearchResults() {
        this.searchOriginResults = null;
        this.searchDestinationResults = null;
      }
     
    handleInputAddress(event){
        console.log('address');
        this.selectedSearchResult=[];
        this.isOrigin=(event.target.name=='origin')?true:false;
        var key = event.target.value;//component.get("v.searchKey");
        if(this.isOrigin && key==''){
            this.selectedOriginValue=null;
        }
        if(!this.isOrigin && key==''){
            this.selectedDestinationValue=null;
        }
        getAddressSet({ 
            SearchText : key
           
        })
        .then(result => {
            var state = "SUCCESS";
            if (state === "SUCCESS") {
                var response = JSON.parse(result);
                var predictions = response.predictions;
                var addresses = [];
                if (predictions.length > 0) {
                    for (var i = 0; i < predictions.length; i++) {
                        var bc =[];
                        addresses.push(
                            {
                                main_text: predictions[i].structured_formatting.main_text, 
                                secondary_text: predictions[i].structured_formatting.secondary_text,
                                place_id: predictions[i].place_id
                            });
                        
                    }
                }
               
                if(this.isOrigin){
                    this.searchDestinationResults=null;
                    this.searchOriginResults=addresses;
                    
                }else{
                    this.searchOriginResults=null;
                    this.searchDestinationResults=addresses;
                }
                
               
            }
        })
        .catch(error => {
            console.log(error);
        });
    }
    handleGetDistance(event){
        
        this.showNavFields=false;
        let enableDirection=false;
        if(this.selectedOriginValue!=null && this.selectedDestinationValue!=null && this.value!=''){
            enableDirection=true;
        }
        if(enableDirection){
            this.showLoader=true;
                    getDistance({ 
                    originLocation : this.selectedOriginValue,
                    destinationLocation:this.selectedDestinationValue,
                    mode:this.value.toLowerCase() 
                
                })
                .then(result => {
                    if(result.status=='OK'){
                        this.distance= result.travelDistance;
                        this.time=result.travelTime;
                        this.cost=result.travelCost;
                        this.showNavFields=true;
                    }else{
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'No Results returned',
                                variant: 'error'
                            })
                        );
                    }
                    this.showLoader=false;
                    
                })
                .catch(error => {
                    console.log(error);
                    this.showLoader=false;
                });
            }else{
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Kindly fill all the fields.',
                        variant: 'error'
                    })
                );
            }
    }
    handleChangeMode(event){
        this.value = event.detail.value;
    }
}