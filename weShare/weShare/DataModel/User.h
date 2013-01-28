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

    const int userId() const {return m_userId;}
    void userId(int userid) { m_userId = userid;}

    const std::wstring& name() const {return m_name;}
    void name(const std::wstring& name) { m_name = name;}
    
    const std::wstring& thumbnialURL() const {return m_urlThumbnail;}
    void thumbnialURL(const std::wstring& url) { m_urlThumbnail = url;}
    
    const std::wstring& email() const {return m_email;}
    void email(const std::wstring& email) { m_email = email;}
    
private:
    int          m_userId;
    std::wstring m_name;
    std::wstring m_urlThumbnail;
    std::wstring m_email;
    
};

#endif /* defined(__weShare__User__) */
