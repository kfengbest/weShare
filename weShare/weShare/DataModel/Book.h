//
//  Book.h
//  weShare
//
//  Created by fengka on 1/26/13.
//  Copyright (c) 2013 adsk. All rights reserved.
//

#ifndef __weShare__Book__
#define __weShare__Book__

#include <iostream>
#include <string>

class Book{
    
public:
    Book();
    ~Book();
    
    const std::string& isbn() const {return m_isbn;}
    void isbn(const std::string& isbn) { m_isbn = isbn;}
    
    const std::wstring& name() const {return m_name;}
    void name(const std::wstring& name) { m_name = name;}
    
    const std::wstring& thumbnialURL() const {return m_urlThumbnail;}
    void thumbnialURL(const std::wstring& url) { m_urlThumbnail = url;}
    
private:
    std::string m_isbn;
    std::wstring m_name;
    std::wstring m_urlThumbnail;
};

#endif /* defined(__weShare__Book__) */
