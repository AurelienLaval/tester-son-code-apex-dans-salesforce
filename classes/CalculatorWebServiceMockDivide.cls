@isTest
global class CalculatorWebServiceMockDivide implements WebServiceMock {
   global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
       
       calculatorWebService.divideResponse_element respElement = new calculatorWebService.divideResponse_element();
       respElement.Result = 5.0;
       response.put('response_x', respElement); 
   }   
}