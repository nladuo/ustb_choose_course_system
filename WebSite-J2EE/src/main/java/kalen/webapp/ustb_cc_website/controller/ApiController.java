package kalen.webapp.ustb_cc_website.controller;

import java.util.Date;
import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import kalen.webapp.ustb_cc_website.dao.Dao;
import kalen.webapp.ustb_cc_website.model.MessageBoard;

@Controller
@RequestMapping(value = "/api")
public class ApiController {

	@RequestMapping(value = "/app_list")
	public ModelMap view_app(ModelMap model) {
		model.addAttribute("code", 1);
		model.addAttribute("data", dao.getAllApps());

		return model;
	}

	@RequestMapping(value = "/comment_list")
	public ModelMap view_comments(ModelMap model) {
		model.addAttribute("code", 1);
		model.addAttribute("data", dao.getAllComments());
		
		return model;
	}

	@RequestMapping(value = "/add", method = RequestMethod.POST)
	public ModelAndView add_comment(HttpServletRequest request,
			HttpServletResponse response) throws UnsupportedEncodingException {

		request.setCharacterEncoding("utf-8");

		//recommend api use object
		//public Map<String, Object> add_comment(MessageBoard messageBoard)
		MessageBoard messageBoard = new MessageBoard();
		messageBoard.setParent_id(Integer.parseInt(request
				.getParameter("parent_id")));
		messageBoard.setNickname(request.getParameter("name"));
		messageBoard.setReplyer_name(request.getParameter("replyer_name"));
		messageBoard.setContent(request.getParameter("comment"));

		SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
		Date time = new Date();
		messageBoard.setTime(f.format(time));

		dao.insertComment(messageBoard);

		return new ModelAndView("redirect: /");

	}

	@Resource(name = "dao")
	Dao dao;

}
