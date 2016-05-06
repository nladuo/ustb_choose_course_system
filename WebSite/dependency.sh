#!/bin/bash
npm install
webpack -p
echo "excuting command: go get github.com/gin-gonic/gin"
go get github.com/gin-gonic/gin
echo "excuting command: go get github.com/jinzhu/gorm"
go get github.com/jinzhu/gorm