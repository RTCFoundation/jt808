<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>实体查看</title>

<%@ include file="/lingx/include/include_JavaScriptAndCss.jsp"%> 
<script type="text/javascript" src="lingx/js/template/tree.js"></script>
<style type="text/css">
.edit_word{font-size:12px;line-height:24px;text-align:right;width:100px;}
</style>
<script type="text/javascript">
var request_params=${REQUEST_PARAMS};

var fromPageId='${param.pageid}';
var entityCode=request_params.e;
var methodCode=request_params.m;
var entityId='${entityId }';
var params=${_params};

params=request_params;
removeDefaultAttribute(params);
var entityFields={};

var cmpId='${param.cmpId}';
var textField='id';
var valueField='id';

if(params&&params.fid){
	entityId=params.fid;
	delete params.fid;
}
</script>
</head>
<body>
</body>

</html>