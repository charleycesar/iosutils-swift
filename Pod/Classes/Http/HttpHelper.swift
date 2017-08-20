//
//  HttpHelper.swift
//  Pods
//
//  Created by Livetouch-Mini01 on 16/06/2016.
//
//

import Foundation
import Security

public enum CertificateMode {
    case none
    case publicKey
}

open class HttpHelper: NSObject, URLSessionDelegate {
    
    //MARK: - Constants
    
    static open let UTF8  = String.Encoding.utf8
    static open let ISO   = String.Encoding.isoLatin1
    
    //MARK: - Variables
    
    //Basic Properties
    
    fileprivate var url         : String!
    fileprivate var contentType : String!
    fileprivate var timeout     : TimeInterval!
    fileprivate var encoding    : String.Encoding!
    
    fileprivate var parameters  : [String: AnyObject]!
    fileprivate var json        : String!
    
    fileprivate var header      : [String: String]!
    
    fileprivate var addDefaultHttpParams    : Bool = false
    
    //Basic Authorization
    
    fileprivate var username    : String!
    fileprivate var password    : String!
    
    //Certificates
    
    fileprivate var certificateMode     : CertificateMode = .none
    
    fileprivate var certificate         : Data?
    fileprivate var certificatePassword : String?
    
    fileprivate var trustAllSSL         : Bool = false
    
    fileprivate var hostDomain          : String?
    
    //Response
    
    fileprivate var responseData    : Data!
    
    fileprivate var responseError   : NSError?
    
    //Semaphore
    
    ///Faz com que a requisição fique síncrona.
    fileprivate var semaphore       : DispatchSemaphore!
    
    //MARK: - Inits
    
    override public init() {
        super.init()
        
        self.contentType = "application/x-www-form-urlencoded"
        self.timeout = 60
        self.encoding = HttpHelper.UTF8
        
        self.header = [:]
        
        self.parameters = [:]
        self.json = ""
    }
    
    convenience public init(contentType: String, timeout: TimeInterval = 60, encoding: String.Encoding = HttpHelper.UTF8) {
        
        self.init()
        
        self.contentType = contentType
        self.timeout = timeout
        self.encoding = encoding
    }
    
    //MARK: - Setters
    
    open func addHeader(key: String, andValue value: String) -> HttpHelper {
        header[key] = value
        return self
    }
    
    open func setContentType(_ contentType: String) -> HttpHelper {
        self.contentType = contentType
        return self
    }
    
    open func setTimeout(_ timeout: TimeInterval) -> HttpHelper {
        self.timeout = timeout
        return self
    }
    
    open func setEncoding(_ encoding: String.Encoding) -> HttpHelper {
        self.encoding = encoding
        return self
    }
    
    open func setAddDefaultHttpParams(_ addDefaultHttpParams: Bool) -> HttpHelper {
        self.addDefaultHttpParams = addDefaultHttpParams
        return self
    }
    
    open func setBasicAuth(username: String, andPassword password: String) -> HttpHelper {
        self.username = username
        self.password = password
        return self
    }
    
    open func setCertificate(_ certificate: Data?, withPassword password: String? = nil) -> HttpHelper {
        if (certificate != nil) {
            self.certificateMode = .publicKey
        }
        
        self.certificate = certificate
        self.certificatePassword = password
        return self
    }
    
    open func setTrustAll(_ trustAllSSL: Bool) -> HttpHelper {
        self.trustAllSSL = trustAllSSL
        return self
    }
    
    open func setHostDomain(_ hostDomain: String) -> HttpHelper {
        self.hostDomain = hostDomain
        return self
    }
    
    //MARK: - Getters
    
    open func getData() -> Data {
        return responseData
    }
    
    open func getJson() -> String {
        if (responseData == nil) {
            return ""
        }
        
        if let json = String(data: responseData, encoding: String.Encoding.utf8) {
            return json
        }
        
        return ""
    }
    
    //MARK: - Conversions
    
    fileprivate func getBase64BasicAuth(_ username: String, password: String) throws -> String {
        let basicAuthCredentials = "\(username):\(password)"
        
        if let basicData = basicAuthCredentials.data(using: String.Encoding.utf8) {
            let base64EncodedCredential = basicData.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
            let authValue = "Basic \(base64EncodedCredential)"
            return authValue
        }
        
        throw Exception.domainException(message: "Erro ao formatar Basic Authentication.")
    }
    
    fileprivate func getStringFromDictionary(_ dictionary: [String: AnyObject]) -> String {
        var resource = ""
        
        for (key, value) in dictionary {
            resource = StringUtils.isEmpty(resource) ? "" : resource + "&"
            resource += key + "=" + "\(value)"
        }
        
        return resource
    }
    
    fileprivate func getDictionaryFromString(_ body: String) throws -> [String: AnyObject] {
        //TODO
        //return try body.toJsonDictionary() as! [String: AnyObject]
        return [:]
    }
    
    //MARK: - Requests
    
    open func get(_ url: String, withParameters parameters: [String: String] = [:]) throws {
        updateUrl(url, withParameters: parameters)
        
        try sendHttpRequest("get")
    }
    
    open func delete(_ url: String, withParameters parameters: [String: String] = [:]) throws {
        updateUrl(url, withParameters: parameters)
        
        try sendHttpRequest("delete")
    }
    
    open func post(_ url: String, withBody body: String) throws {
        updateUrl(url)
        
        self.json = body
        
        try sendHttpRequest("post")
    }
    
    open func post(_ url: String, withParameters parameters: [String: AnyObject]) throws {
        updateUrl(url)
        
        self.parameters = parameters
        
        try sendHttpRequest("post")
    }
    
    open func update(_ url: String, withBody body: String) throws {
        updateUrl(url)
        
        self.json = body
        
        try sendHttpRequest("update")
    }
    
    open func update(_ url: String, withParameters parameters: [String: AnyObject]) throws {
        updateUrl(url)
        
        self.parameters = parameters
        
        try sendHttpRequest("update")
    }
    
    fileprivate func sendHttpRequest(_ requestMethod: String) throws {
        
        guard let nsurl = URL(string: url) else {
            throw Exception.domainException(message: "URL inválida.")
        }
        
        let request = NSMutableURLRequest(url: nsurl, cachePolicy: .useProtocolCachePolicy, timeoutInterval: timeout)
        request.httpMethod = requestMethod
        
        if let username = username , username.isNotEmpty {
            if let password = password , password.isNotEmpty {
                let encodedBasicAuth = try getBase64BasicAuth(username, password: password)
                
                request.setValue(encodedBasicAuth, forHTTPHeaderField: "Authorization")
            }
        }
        
        if (header.count > 0) {
            for (key, value) in header {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        if (requestMethod.equalsIgnoreCase(string: "post") || requestMethod.equalsIgnoreCase(string: "update")) {
            if (self.parameters.isEmpty && StringUtils.isEmpty(json)) {
                throw Exception.domainException(message: "Requisição http (\(requestMethod.lowercased()) sem parâmetros).")
            }
            
            if (request.value(forHTTPHeaderField: "Content-Type") == nil) {
                request.setValue(contentType, forHTTPHeaderField: "Content-Type")
            }
            
            let hasJsonString = StringUtils.isNotEmpty(json)
            
            if (contentType == "application/x-www-form-urlencoded") {
                if (hasJsonString) {
                    throw Exception.domainException(message: "User dicionário para content-type application/x-www-form-urlencoded")
                }
                
                let formString = getStringFromDictionary(parameters)
                let length = "\(formString.length)"
                
                request.setValue(length, forHTTPHeaderField: "Content-Length")
                request.httpBody = formString.data(using: String.Encoding.utf8)
            } else {
                do {
                    if (hasJsonString) {
                        let data = json.data(using: String.Encoding.utf8)!
                        request.httpBody = data
                    } else {
                        let data = try JSONSerialization.data(withJSONObject: parameters, options: [])
                        
                        request.httpBody = data
                    }
                } catch {
                    throw Exception.domainException(message: "Erro ao formatar os dados de envio.")
                }
            }
        }
        
        semaphore = DispatchSemaphore(value: 0)
        
        let configuration = URLSessionConfiguration.default
        
        let session = Foundation.URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        //TODO
        /*let dataTask = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: NSError?) in
            if let error = error {
                self.responseError = error
                LogUtils.log("Http Error: \(error.localizedDescription)")
            }
            
            if let data = data {
                self.responseData = data
            }
            
            self.semaphore.signal()
        })*/
        
        //dataTask.resume()
        
        semaphore.wait(timeout: DispatchTime.distantFuture)
        
        session.finishTasksAndInvalidate()
        
        if let error = responseError {
            if (error.code == -1022) {
                throw Exception.appSecurityTransportException
            }
            throw Exception.ioException
        }
        
        if (responseData == nil) {
            throw Exception.ioException
        }
    }
    
    //MARK: - Url Parameters
    
    fileprivate func updateUrl(_ url: String, withParameters parameters: [String: String] = [:]) {
        self.url = url
        
        let queryString = getUrlParams(parameters, withDefaultHttpParams: addDefaultHttpParams)
        if (StringUtils.isNotEmpty(queryString)) {
            self.url = self.url + "?" + queryString
        }
    }
    
    fileprivate func getDefaultHttpParameters() -> [String: String] {
        var params : [String: String] = [:]
        
        let so = "iOS"
        let soVersion = "\(DeviceUtils.getVersion())"
        let width = "\(DeviceUtils.getScreenWidth() * DeviceUtils.getScreenScale())"
        let height = "\(DeviceUtils.getScreenHeight() * DeviceUtils.getScreenScale())"
        let deviceName = DeviceUtils.getName()
        let appVersion = AppUtils.getVersion()
        
        params["device.so"] = so
        params["device.so_version"] = soVersion
        params["device.width"] = width
        params["device.height"] = height
        params["device.imei"] = DeviceUtils.getUUID()
        params["device.name"] = deviceName
        params["app.version"] = appVersion
        params["app_version"] = appVersion
        params["app.version_code"] = ""
//        params.put("app.version_code", String.valueOf(AndroidUtils.getAppVersionCode()));
        params["so.version"] = soVersion
        
        return params
    }
    
    fileprivate func getUrlParams(_ parameters: [String: String], withDefaultHttpParams addDefaultHttpParams: Bool) -> String {
        
        var parameters = parameters
        let defaultMap : [String: String] = addDefaultHttpParams ? getDefaultHttpParameters() : [:]
        
        if (!parameters.isEmpty) {
            for (key, value) in defaultMap {
                parameters[key] = value
            }
        } else {
            parameters = defaultMap
        }
        
        let urlParams = getStringFromDictionary(parameters as [String : AnyObject])
        
        return urlParams
    }
    
    //MARK: - Certificate Handlers
    
    open func shoultTrustProctectionSpace(_ protectionSpace: URLProtectionSpace, withCertificate certificate: Data) -> Bool {
        
//        guard let serverTrust = protectionSpace.serverTrust else {
//            return false
//        }
//        
//        let cfData = certificate as CFData
//        
//        guard let secCert = SecCertificateCreateWithData(nil, cfData) else {
//            return false
//        }
//        
//        let cfArray = CFArrayCreate(nil, secCert as! UnsafeMutablePointer<UnsafePointer<Void>>, 1, nil)
//        SecTrustSetAnchorCertificates(serverTrust, cfArray)
//        
//        var trustResult = SecTrustResultType()
//        
//        guard errSecSuccess == SecTrustEvaluate(serverTrust, &trustResult) else {
//            LogUtils.log("SecTrustEvaluate is not errSecSuccess")
//            return false
//        }
//        
//        if (trustResult == UInt32(kSecTrustResultRecoverableTrustFailure)) {
//            let errDataRef = SecTrustCopyExceptions(serverTrust)
//            SecTrustSetExceptions(serverTrust, errDataRef)
//            
//            SecTrustEvaluate(serverTrust, &trustResult)
//        }
//        
//        return trustResult == UInt32(kSecTrustResultProceed) || trustResult == UInt32(kSecTrustResultUnspecified)
        
        return false
    }
    
    open func loadCertificate(_ certificate: Data, withPassword password: String) -> AnyObject {
        
//        NSData* p12data = self.certificate;
//        
//        const void *keys[] = {kSecImportExportPassphrase};
//        const void *values[] = {(__bridge CFStringRef)self.certificatePassword};
//        
//        CFDictionaryRef optionsDictionary = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
//        CFArrayRef p12Items;
//        OSStatus result = SecPKCS12Import((__bridge CFDataRef) p12data, optionsDictionary, &p12Items);
//        
//        if (result == noErr) {
//            CFDictionaryRef identityDict = CFArrayGetValueAtIndex(p12Items, 0);
//            SecIdentityRef identityApp = (SecIdentityRef) CFDictionaryGetValue(identityDict, kSecImportItemIdentity);
//            SecCertificateRef certRef;
//            SecIdentityCopyCertificate(identityApp, &certRef);
//            SecCertificateRef certArray[1] = {certRef};
//            CFArrayRef myCerts = CFArrayCreate(NULL, (void *) certArray, 1, NULL);
//            CFRelease(certRef);
//            
//            NSURLCredential *credential = [NSURLCredential credentialWithIdentity:identityApp certificates:nil persistence:NSURLCredentialPersistenceNone];
//            CFRelease(myCerts);
//            return credential;
//            
//        } else {
//            // Certificate is invalid or password is invalid given the certificate
//            [LTLogUtils log:@"Invalid certificate or password"];
//            return nil;
//        }
        
        return String() as AnyObject
    }
    
    //MARK: - URL Session Delegate
    
    open func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        guard let error = error else {
            return
        }
        
        responseError = error as NSError?
        LogUtils.log(error.localizedDescription)
        
        semaphore.signal()
    }
    
    open func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        if let hostDomain = hostDomain , hostDomain.isNotEmpty {
            if !hostDomain.equalsIgnoreCase(string: challenge.protectionSpace.host) {
                completionHandler(.rejectProtectionSpace, nil)
            }
        }
        
        if trustAllSSL {
            if let serverTrust = challenge.protectionSpace.serverTrust {
                let credential = URLCredential(trust: serverTrust)
                completionHandler(.useCredential, credential)
            }
        } else if certificateMode == .publicKey {
            if let certificate = certificate {
                if shoultTrustProctectionSpace(challenge.protectionSpace, withCertificate: certificate) {
                    if let certificatePassword = certificatePassword {
                        let credential = loadCertificate(certificate, withPassword: certificatePassword)
                        completionHandler(.useCredential, credential as? URLCredential)
                        
                    } else {
                        if let serverTrust = challenge.protectionSpace.serverTrust {
                            let credential = URLCredential(trust: serverTrust)
                            completionHandler(.useCredential, credential)
                        }
                    }
                } else {
                    completionHandler(.performDefaultHandling, nil)
                }
            } else {
                completionHandler(.cancelAuthenticationChallenge, nil)
            }
        } else {
            completionHandler(.performDefaultHandling, nil)
        }
    }
}
