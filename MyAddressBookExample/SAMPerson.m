//
//  SAMPerson.m
//  MyAddressBookExample
//
//  Created by Milan Kumar Panchal on 06/02/14.
//  Copyright (c) 2014 Pantech. All rights reserved.
//

#import "SAMPerson.h"

@implementation SAMPerson

- (id)init {
    self = [super init];
    if (self) {
        
        
        self.firstName          = @"Milan";
        self.lastName           = @"Panchal";
        self.nickName           = @"SAM";
        self.organizationName   = @"Pantech";
        
        self.displayPic         = [UIImage imageNamed:@"sam.jpg"];
        
        self.skypeId            = @"milan_panchal24";
        self.twitterId          = @"milan_panchal24";
        self.facebookId         = @"MilanPantech";
        self.linkedinId         = @"milanpanchal";
        
        self.emailAddresses     = @[@"sam07it22@gmail.com"];
        self.blogUrls           = @[@"http://www.techfuzionwithsam.wordpress.com",@"http://www.mypoemswithsam.wordpress.com"];
        
        
    }
    return self;
}

@end
