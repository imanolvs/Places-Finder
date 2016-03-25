//
//  EMTConstants.swift
//  Moving in Madrid
//
//  Created by Imanol Viana Sánchez on 9/3/16.
//  Copyright © 2016 Imanol Viana Sánchez. All rights reserved.
//


class EMTConstants {
    
    struct EMT {
        
        static let BaseURLMethod = "https://openbus.emtmadrid.es:9443/emt-proxy-server/last"
        static let APIKey = "E516CC0A-1655-46BE-A548-37AC7F780404"
        static let ClientID = "WEB.SERV.imanolvs@gmail.com"
    }
    
    struct Methods {
        
        static let GetCalendar = "/bus/GetCalendar.php"
        static let BusGetGroups = "/bus/GetGroups.php"
        static let GetListLines = "/bus/GetListLines.php"
        static let GetNodesLines = "/bus/GetNodesLines.php"
        static let GetRouteLines = "/bus/GetRouteLines.php"
        static let GetRouteLinesRoute = "/bus/GetRouteLinesRoute.php"
        static let GetTimesLines = "/bus/GetTimesLines.php"
        static let GetTimeTableLines = "/bus/GetTimeTableLines.php"
        static let GetArriveStop = "/geo/GetArriveStop.php"
        static let GetGroups = "/geo/GetGroups.php"
        static let GetInfoLine = "/geo/GetInfoLine.php"
        static let GetInfoLineExtended = "/geo/GetInfoLineExtend.php"
        static let GetPointsOfInterest = "/geo/GetPointsOfInterest.php"
        static let GetPointsOfInterestTypes = "/geo/GetPointsOfInterestTypes.php"
        static let GetStopsFromStop = "/geo/GetStopsFromStop.php"
        static let GetStopsFromXY = "/geo/GetStopsFromXY.php"
        static let GetStopsLine = "/geo/GetStopsLine.php"
        static let GetStreet = "/geo/GetStreet.php"
        static let GetStreetFromXY = "/geo/GetStreetFromXY.php"
        static let GetEstimatesIncident = "/media/GetEstimatesIncident.php"
        static let GetStreetRoute = "/media/GetStreetRoute.php"
        static let ConfirmSubscription = "/client/ConfirmSubscription.php"
        static let ConsultSubscription = "/client/ConsultSubscription"
        static let DropSubscription = "/client/DropSubscription"
        static let ModifySubscription = "/client/ModifySubscription"
        static let NewSubscription = "/client/NewSubscription"
        static let SendSuggestion = "/client/Suggestion"
        static let LogonAppWithWorkstation = "/nfc/security/LogonAppWithWorkStation.php"
        static let GetListApps = "/nfc/desfiredmz/GetListApps.php"
        static let OperationDesfire = "/nfc/desfiredmz/OperationDesfire.php"
        static let CommandDesfire = "/nfc/desfiredmz/CommandDesfire.php"
    }
    
    struct GetStopsFromXYKeys {
        
        static let ClientID = "idClient"
        static let PassKey = "passKey"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let Radius = "Radius"
        static let CultureInfo = "cultureInfo"
    }
    
    struct GetStopsFromXYResponseKeys {
        
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let Stop = "stop"
    }
    
}