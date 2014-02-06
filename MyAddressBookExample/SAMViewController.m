//
//  SAMViewController.m
//  MyAddressBookExample
//
//  Created by Milan Kumar Panchal on 06/02/14.
//  Copyright (c) 2014 Pantech. All rights reserved.
//

#import "SAMViewController.h"
#import <AddressBook/AddressBook.h>
#import "SAMPerson.h"

@interface SAMViewController ()

@end

@implementation SAMViewController

#pragma mark - view life cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveContactToAddressBook:(id)sender {
    
    SAMPerson *person = [[SAMPerson alloc] init];
    
    CFErrorRef error = NULL;
    
    ABAddressBookRef iPhoneAddressBook;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")){
        iPhoneAddressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(iPhoneAddressBook,  ^(bool granted, CFErrorRef error){
            dispatch_semaphore_signal(sema);
        });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
    } else {
        iPhoneAddressBook = ABAddressBookCreate();
    }
    
    ABRecordRef newPerson = ABPersonCreate();
    
    // First Name - Last Name - Nickname - Company Name
    ABRecordSetValue(newPerson, kABPersonFirstNameProperty, (__bridge CFTypeRef)(person.firstName), &error);
    ABRecordSetValue(newPerson, kABPersonLastNameProperty, (__bridge CFTypeRef)(person.lastName), &error);
    ABRecordSetValue(newPerson, kABPersonNicknameProperty, (__bridge CFTypeRef)(person.nickName), &error);
    ABRecordSetValue(newPerson, kABPersonOrganizationProperty, (__bridge CFTypeRef)(person.organizationName), &error);
    
    
    
    //  Add Emial addresses
    ABMutableMultiValueRef multiEmail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    for (NSString *email in person.emailAddresses) {
        ABMultiValueAddValueAndLabel(multiEmail, (__bridge CFTypeRef)(email), kABHomeLabel, NULL);
    }
    ABRecordSetValue(newPerson, kABPersonEmailProperty, multiEmail, &error);
    CFRelease(multiEmail);
    
    
    //  Adding social and Skype
    ABMultiValueRef social = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
    
    ABMultiValueAddValueAndLabel(social, (__bridge CFTypeRef)([NSDictionary dictionaryWithObjectsAndKeys:
                                                               (NSString *)kABPersonInstantMessageServiceSkype, kABPersonInstantMessageServiceKey,
                                                               person.skypeId, kABPersonInstantMessageUsernameKey,
                                                               nil]), kABPersonInstantMessageServiceSkype, NULL); // For Skype
    
    ABMultiValueAddValueAndLabel(social, (__bridge CFTypeRef)([NSDictionary dictionaryWithObjectsAndKeys:
                                                               (NSString *)kABPersonSocialProfileServiceTwitter, kABPersonSocialProfileServiceKey,
                                                               person.twitterId, kABPersonSocialProfileUsernameKey,
                                                               nil]), kABPersonSocialProfileServiceTwitter, NULL); // For Twitter
    
    ABMultiValueAddValueAndLabel(social, (__bridge CFTypeRef)([NSDictionary dictionaryWithObjectsAndKeys:
                                                               (NSString *)kABPersonSocialProfileServiceFacebook, kABPersonSocialProfileServiceKey,
                                                               person.facebookId, kABPersonSocialProfileUsernameKey,
                                                               nil]), kABPersonSocialProfileServiceFacebook, NULL); // For Facebook
    
    ABMultiValueAddValueAndLabel(social, (__bridge CFTypeRef)([NSDictionary dictionaryWithObjectsAndKeys:
                                                               (NSString *)kABPersonSocialProfileServiceLinkedIn, kABPersonSocialProfileServiceKey,
                                                               person.linkedinId, kABPersonSocialProfileUsernameKey,
                                                               nil]), kABPersonSocialProfileServiceLinkedIn, NULL); // For LinkedIn
    
    
    ABRecordSetValue(newPerson, kABPersonSocialProfileProperty, social, &error);
    
    
    // Add an image
    NSData *dataRef = UIImagePNGRepresentation(person.displayPic);
    ABPersonSetImageData(newPerson, (__bridge CFDataRef)dataRef, &error);
    
    // URL
    ABMutableMultiValueRef urlMultiValue = ABMultiValueCreateMutable(kABStringPropertyType);
    for (NSString *blogUrl in person.blogUrls) {
        ABMultiValueAddValueAndLabel(urlMultiValue, (__bridge CFTypeRef)(blogUrl), kABPersonHomePageLabel, NULL);
    }
    
    ABRecordSetValue(newPerson, kABPersonURLProperty, urlMultiValue, &error);
    CFRelease(urlMultiValue);
    
    
    ABAddressBookAddRecord(iPhoneAddressBook, newPerson, &error);
    ABAddressBookSave(iPhoneAddressBook, &error);
    
    if (error != NULL) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Could not create unknown user"
                                                       delegate:nil
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Added Successfully!"
                                                        message:[NSString stringWithFormat:@"%@ %@ was added to your contact successfully.",person.firstName,person.lastName]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    
    CFRelease(newPerson);
    CFRelease(iPhoneAddressBook);
    
}

@end
