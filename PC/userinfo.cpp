#include "userinfo.h"
UserInfo* UserInfo::userInfo = NULL;

UserInfo::UserInfo()
{

}

/**
 * @brief UserInfo::getInstance
 * @return
 */
UserInfo* UserInfo::getInstance (){
    if(userInfo == NULL){
        userInfo = new UserInfo;
    }
    return userInfo;
}

