package kalen.webapp.ustb_cc_website.controller;

import java.util.Date;
import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import org.springframework.web.servlet.view.json.MappingJackson2JsonView;

import kalen.webapp.ustb_cc_website.dao.Dao;
import kalen.webapp.ustb_cc_website.model.MessageBoard;

@Controller
@RequestMapping(value="/api")
public class ApiController {
	
	@Resource(name="dao")
	Dao dao;
	
	@RequestMapping(value="/app_list")
	public ModelAndView view_app(){
		Map<String, Object> attributes=new HashMap<String, Object>();  
		attributes.put("code", 1); 
		attributes.put("data", dao.getAllApps());
        
        MappingJackson2JsonView view = new MappingJackson2JsonView();
        view.setAttributesMap(attributes);
        
        return new ModelAndView(view);
	}
	
	@RequestMapping(value="/comment_list")
	public ModelAndView view_comments(){
		Map<String, Object> attributes=new HashMap<String, Object>();  
		attributes.put("code", 1); 
		attributes.put("data", dao.getAllComments());
        
        MappingJackson2JsonView view = new MappingJackson2JsonView();
        view.setAttributesMap(attributes);
        
        return new ModelAndView(view);
	}
	
	@RequestMapping(value="/add", method= RequestMethod.POST)
	public ModelAndView add_comment(HttpServletRequest request, 
			HttpServletResponse response) throws UnsupportedEncodingException{
		
		request.setCharacterEncoding("utf-8");
		
		MessageBoard messageBoard = new MessageBoard();
		messageBoard.setParent_id(Integer.parseInt(request.getParameter("parent_id")));
		messageBoard.setNickname(request.getParameter("name"));
		messageBoard.setReplyer_name(request.getParameter("replyer_name"));
		messageBoard.setContent(request.getParameter("comment"));
		
		SimpleDateFormat f=new SimpleDateFormat("yyyy-MM-dd hh:mm:ss"); 
		Date time = new Date();
		messageBoard.setTime(f.format(time));
		
		
		System.out.println(messageBoard.getTime());
		
		dao.insertComment(messageBoard);
	
        
        return new ModelAndView("redirect: /");
		
	}
	
	
	
	

}
