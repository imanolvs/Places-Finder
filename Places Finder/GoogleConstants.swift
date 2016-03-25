//
//  GoogleConstants.swift
//  Places Finder
//
//  Created by Imanol Viana Sánchez on 9/3/16.
//  Copyright © 2016 Imanol Viana Sánchez. All rights reserved.
//


class GoogleConstants {
    
    // MARK: GooglePlaces Constants for requests
    struct GooglePlaces {
        
        static let BaseURLMethod = "https://maps.googleapis.com/maps/api/place"
        static let APIKey = "AIzaSyDui53xdw4je8U62G3b_DowKQ9Vywzossc"
    }
    
    struct Methods {
        
        static let NearbySearchMethod = "/nearbysearch/json?"
        static let TextSearchMethod = "/textsearch/json?"
        static let RadarSearchMethod = "/radarsearch/json?"
        static let DetailsMethod = "/details/json?"
        static let PhotoMethod = "/photo?"
    }
    
    // MARK: Request Parameters Keys
    struct ParameterKeys {
        
        static let APIKey = "key"
        static let Query = "query"
        static let Location = "location"
        static let Radius = "radius"
        static let Type = "type"
        static let Name = "name"
        static let PlaceID = "placeid"
        static let MinPrice = "minprice"
        static let MaxPrixe = "maxprice"
        static let OpenNow = "opennow"
        static let PageToken = "pagetoken"
        static let PhotoReference = "photoreference"
        static let MaxWidth = "maxwidth"
        static let MaxHeight = "maxheight"
        static let Language = "language"
    }
    
    struct Languages {
        
        static let Arabic = "ar"
        static let Bulgarian = "bg"
        static let Catalan = "ca"
        static let Czech = "cs"
        static let Danish = "da"
        static let German = "de"
        static let Greek = "el"
        static let English = "en"
        static let Spanish = "es"
        static let Finnish = "fi"
        static let French = "fr"
        static let Hindi = "hi"
        static let Italian = "it"
        static let Japanese = "ja"
        static let Korean = "ko"
        static let Lithuanian = "lt"
        static let Latvian = "lv"
        static let Dutch = "nl"
        static let Norwegian = "no"
        static let Polish = "pl"
        static let Portuguese = "pt"
        static let Romanian = "ro"
        static let Russian = "ru"
        static let Swedish = "sv"
        static let Turkish = "tr"
        static let Ukrainian = "uk"
    }
    
    struct SearchTypesValues {
        
        static let Restaurant = "restaurant"
        static let Lodging = "lodging"
        
        static let AmusementPark = "amusement_park"
        static let ArtGallery = "art_gallery"
        static let ShoppingMall = "shopping_mall"
        static let BowlingAlley = "bowling_alley"
        static let MovieTheater = "movie_theater"
        static let NightClub = "night_club"
        static let Casino = "casino"
        static let Museum = "museum"
        static let Church = "church"
        static let Mosque = "mosque"
        static let Synagogue = "synagogue"
        static let Stadium = "stadium"
        static let Gym = "gym"
        static let Zoo = "zoo"
    }
    
    // MARK: Place Search Response Keys
    struct SearchResponseKeys {
        
        static let NextPageToken = "next_page_token"
        static let Results = "results"
        static let Status = "status"
        
        // MARK: Keys to get the place location
        static let FormattedAddress = "formatted_address"
        static let Geometry = "geometry"
        static let Location = "location"
        static let Latitude = "lat"
        static let Longitude = "lng"
        
        // MARK: Keys to get the info about open schedule
        static let OpeningHours = "opening_hours"
        static let OpenNow = "open_now"
        static let WeeakDayText = "weekday_text"
        
        // MARK: 
        static let Photos = "photos"
        static let Height = "height"
        static let Width = "width"
        static let PhotoReference = "photo_reference"
        static let HTMLAttributions = "html_attributions"
        
        // MARK: 
        static let PlaceIcon = "icon"
        static let Name = "name"
        static let PlaceID = "place_id"
        static let Rating = "rating"
        static let Reference = "reference"
        static let Types = "types"
        static let Vicinity = "vicinity"
    }
    
    struct DetailsResponseKeys {
        
        static let Result = "result"
        
        // MARK: Address Components Keys
        static let AddressComponents = "address_components"
        static let LongName = "long_name"
        static let ShortName = "short_name"
        static let Types = "types"
        
        // MARK: Formatted Address and phone number
        static let FormattedAddress = "formatted_address"
        static let FormattedPhone = "formatted_phone_number"
        static let Website = "website"
        
        // MARK: Opening Hours Details
        static let Periods = "periods"
        static let OpeningHours = "opening_hours"
        static let OpenNow = "open_now"
        static let WeeakDayText = "weekday_text"

        // MARK: Review Keys
        static let Reviews = "reviews"
        static let AuthorName = "author_name"
        static let AuthorURL = "author_url"
        static let ReviewText = "text"
        static let Language = "language"
        static let Time = "time"

        static let Aspects = "aspects"
        static let Rating = "rating"
        static let RatingType = "type"
    }
    
    // MARK: Some Response Values
    struct ResponseValues {
        
        static let OKStatus = "OK"
        static let ZeroResults = "ZERO_RESULTS"
        static let OverQueryLimit = "OVER_QUERY_LIMIT"
        static let RequestDenied = "REQUEST_DENIED"
        static let InvalidRequest = "INVALID_REQUEST"
    }
}