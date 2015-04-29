//
//  FKFlickrPeopleFindByEmail.h
//  FlickrKit
//
//  Generated by FKAPIBuilder on 19 Sep, 2014 at 10:49.
//  Copyright (c) 2013 DevedUp Ltd. All rights reserved. http://www.devedup.com
//
//  DO NOT MODIFY THIS FILE - IT IS MACHINE GENERATED


#import "FKFlickrAPIMethod.h"

typedef enum {
	FKFlickrPeopleFindByEmailError_UserNotFound = 1,		 /* No user with the supplied email address was found. */
	FKFlickrPeopleFindByEmailError_InvalidAPIKey = 100,		 /* The API key passed was not valid or has expired. */
	FKFlickrPeopleFindByEmailError_ServiceCurrentlyUnavailable = 105,		 /* The requested service is temporarily unavailable. */
	FKFlickrPeopleFindByEmailError_WriteOperationFailed = 106,		 /* The requested operation failed due to a temporary issue. */
	FKFlickrPeopleFindByEmailError_FormatXXXNotFound = 111,		 /* The requested response format was not found. */
	FKFlickrPeopleFindByEmailError_MethodXXXNotFound = 112,		 /* The requested method was not found. */
	FKFlickrPeopleFindByEmailError_InvalidSOAPEnvelope = 114,		 /* The SOAP envelope send in the request could not be parsed. */
	FKFlickrPeopleFindByEmailError_InvalidXMLRPCMethodCall = 115,		 /* The XML-RPC request document could not be parsed. */
	FKFlickrPeopleFindByEmailError_BadURLFound = 116,		 /* One or more arguments contained a URL that has been used for abuse on Flickr. */

} FKFlickrPeopleFindByEmailError;

/*

Return a user's NSID, given their email address


Response:

<user nsid="12037949632@N01">
	<username>Stewart</username> 
</user>

*/
@interface FKFlickrPeopleFindByEmail : NSObject <FKFlickrAPIMethod>

/* The email address of the user to find  (may be primary or secondary). */
@property (nonatomic, copy) NSString *find_email; /* (Required) */


@end