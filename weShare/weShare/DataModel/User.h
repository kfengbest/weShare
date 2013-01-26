//
//  User.h
//  weShare
//
//  Created by fengka on 1/26/13.
//  Copyright (c) 2013 adsk. All rights reserved.
//

#ifndef __weShare__User__
#define __weShare__User__

#include <iostream>

class User{
    
public:
    User();
    ~User();
        
    const std::wstring& name() const {return m_name;}
    void name(const std::wstring& name) { m_name = name;}
    
    const std::wstring& thumbnialURL() const {return m_urlThumbnail;}
    void thumbnialURL(const std::wstring& url) { m_urlThumbnail = url;}
    
private:
    std::wstring m_name;
    std::wstring m_urlThumbnail;
};

#endif /* defined(__weShare__User__) */
