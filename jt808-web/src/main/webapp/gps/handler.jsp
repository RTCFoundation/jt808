﻿<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ page import="com.lingx.gps.service.*,com.lingx.core.utils.Utils,com.lingx.core.model.bean.UserBean,com.lingx.core.service.*,com.lingx.core.Constants,com.lingx.core.service.*,com.lingx.core.model.*,java.util.*,com.alibaba.fastjson.JSON,org.springframework.context.ApplicationContext,org.springframework.web.context.support.WebApplicationContextUtils,org.springframework.jdbc.core.JdbcTemplate" %>
<%!
public String getLanguage(HttpSession session){
	if(session.getAttribute("SESSION_LANGUAGE")==null)return "zh_CN";
	return session.getAttribute("SESSION_LANGUAGE").toString();
}
%>
<%
String jt1078Ip="127.0.0.1";
String cmd=request.getParameter("c");
ApplicationContext spring = WebApplicationContextUtils.getRequiredWebApplicationContext(request.getSession().getServletContext());
JdbcTemplate jdbc=spring.getBean(JdbcTemplate.class);
com.lingx.core.service.II18NService i18n=spring.getBean(com.lingx.core.service.II18NService.class);
com.lingx.jt808.service.JT808CommandService commandService=spring.getBean(com.lingx.jt808.service.JT808CommandService.class);

com.lingx.core.service.ILingxService lingx=spring.getBean(com.lingx.core.service.ILingxService.class);
UserBean userBean=null;
if(session.getAttribute(Constants.SESSION_USER)==null)return;
userBean=(UserBean)session.getAttribute(Constants.SESSION_USER);
Map<String,Object> ret=new HashMap<String,Object>();
if("getTreeList".equals(cmd)){
	String text=request.getParameter("text");
	String node=request.getParameter("node");
	String checkbox=request.getParameter("checkbox");
	String groupWhere1="",groupWhere2="";

	if(Utils.isNotNull(text)){
		List<Map<String,Object>> list2=jdbc.queryForList("select id,carno text,id value,speed from tgps_car where (carno like '%"+text+"%' or id like '%"+text+"%' or czxm like '%"+text+"%') order by online desc");
		for(Map<String,Object> map:list2){
			
			map.put("iconCls", "carStatus_3");
			map.put("id",0+"_"+map.get("id"));
			map.put("leaf",true);
			if("true".equals(checkbox))
			map.put("checked",false);
			

		}
		out.println(JSON.toJSONString(list2));
	}else{
		List<Map<String,Object>> list=null;
		if("0".equals(node)){
			list=jdbc.queryForList("select id,name text,id value,icon_cls from tgps_group where 1=1 order by orderindex asc,convert(name using gbk) asc");
			
		}else{
			list=jdbc.queryForList("select id,name text,id value,icon_cls from tgps_group where fid=?  order by orderindex asc,convert(name using gbk) asc",node);
		}
		 for(Map<String,Object> map:list){
			if("0".equals(node)){
				map.put("nodeType", "async");
			map.put("expanded",false);//2016-12-28改为false
			}
			if("true".equals(checkbox))
			map.put("checked",false);
		
		} 
		 {//根据分组ID取车辆
			List<Map<String,Object>> list2=jdbc.queryForList("select id,carno text,id value,speed from tgps_car where id in(select car_id from tgps_group_car where group_id=?) order by online desc, convert(carno using gbk) asc",node);
			for(Map<String,Object> map:list2){
				Map<String,Object> cache=com.lingx.jt808.IJT808Cache.CACHE_0x0200.getIfPresent(map.get("id").toString());
				
				map.put("iconCls", "carStatus_3");
				map.put("id",node+"_"+map.get("id"));
				map.put("leaf",true);
				if("true".equals(checkbox))
				map.put("checked",false);
				

			}
			list.addAll(list2);
		
		 }
		out.println(JSON.toJSONString(list));
	}
}else if("send9101".equals(cmd)){
	String tid=request.getParameter("tid");
	String tdh=request.getParameter("tdh");
	String ip=jt1078Ip;
	String port="1078";
	com.lingx.jt808.cmd.Cmd9101 cmd9101=new com.lingx.jt808.cmd.Cmd9101(tid,ip,port,tdh);
	commandService.sendCmd(cmd9101);
	out.println(JSON.toJSONString(ret));
}else if("send9102".equals(cmd)){
	String tid=request.getParameter("tid");
	String tdh=request.getParameter("tdh");
	com.lingx.jt808.cmd.Cmd9102 cmd9102=new com.lingx.jt808.cmd.Cmd9102(tid,tdh);
	commandService.sendCmd(cmd9102);
	out.println(JSON.toJSONString(ret));
}else if("send9201".equals(cmd)){
	String tid=request.getParameter("tid");
	String tdh=request.getParameter("tdh");
	String stime=request.getParameter("stime");
	String etime=request.getParameter("etime");
	String type=request.getParameter("type");
	String mltype=request.getParameter("mltype");
	String zcqtype=request.getParameter("zcqtype");

	String ip=jt1078Ip;
	String port="1078";
	
	System.out.println("下发回放视频指令："+tid);
	com.lingx.jt808.cmd.Cmd9201 cmd9201=new com.lingx.jt808.cmd.Cmd9201(tid,ip,port,tdh,"0",mltype,zcqtype,stime,etime);
	commandService.sendCmd(cmd9201);
	out.println(JSON.toJSONString(ret));
}else if("send9202".equals(cmd)){
	String tid=request.getParameter("tid");
	String tdh=request.getParameter("tdh");
	com.lingx.jt808.cmd.Cmd9202 cmd9202=new com.lingx.jt808.cmd.Cmd9202(tid,tdh);
	commandService.sendCmd(cmd9202);
	out.println(JSON.toJSONString(ret));
}else if("send9205".equals(cmd)){
	String tid=request.getParameter("tid");
	String tdh=request.getParameter("tdh");
	String stime=request.getParameter("stime");
	String etime=request.getParameter("etime");
	String type=request.getParameter("type");
	String ml=request.getParameter("ml");
	String zcqtype=request.getParameter("zcq");

	System.out.println("下发查询视频指令："+tid);
	com.lingx.jt808.cmd.Cmd9205 cmd9205=new com.lingx.jt808.cmd.Cmd9205(tid,tdh,stime,etime,type,ml,zcqtype);
	com.lingx.jt808.bean.RetBean obj=commandService.sendCmd(cmd9205);
	System.out.println(JSON.toJSONString(obj));
	session.setAttribute(tid,obj);
	System.out.println("存到session了");
	//System.out.println(JSON.toJSONString(ret1));
	out.println(JSON.toJSONString(ret));
}else if("getMediaList".equals(cmd)){
	String tid=request.getParameter("tid");
	if(session.getAttribute(tid)==null) {
		out.print("[]");
		return;
	}
	
	com.lingx.jt808.bean.RetBean retBean=(com.lingx.jt808.bean.RetBean)session.getAttribute(tid);
	List<Map<String,Object>> list=null;
	try{
	if(retBean!=null){
		java.text.SimpleDateFormat sdf=new java.text.SimpleDateFormat("yyyyMMddHHmmss");
		list=retBean.getParams();
		for(Map<String,Object> map1:list){
			map1.put("time", sdf.parse(map1.get("etime").toString()).getTime()-sdf.parse(map1.get("stime").toString()).getTime() );
			map1.put("timeView", map1.get("stime").toString()+map1.get("etime").toString().substring(8) );
		}
	}else{
		list=new ArrayList<>();
	}
	
	}catch(Exception e){
		e.printStackTrace();
		list=new ArrayList<>();
	}
	ret.put("rows", list);
	ret.put("total", list.size());
	session.removeAttribute(tid);
	out.println(JSON.toJSONString(ret));
}else{
	System.out.println("参数c的值有误:"+cmd+","+request.getServletPath());
}
%>