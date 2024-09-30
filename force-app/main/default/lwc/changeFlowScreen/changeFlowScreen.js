import { LightningElement, api } from 'lwc';
import {FlowAttributeChangeEvent, FlowNavigationBackEvent, FlowNavigationNextEvent } from 'lightning/flowSupport';

export default class ChangeFlowScreen extends LightningElement {

    @api showNext;
    @api showPrevious;

    handleNext(){
        const navigateNextEvent = new FlowNavigationNextEvent();
        this.dispatchEvent(navigateNextEvent);
    }

    handlePrevious(){
        const navigateBackEvent = new FlowNavigationBackEvent();
        this.dispatchEvent(navigateBackEvent);
    }
}