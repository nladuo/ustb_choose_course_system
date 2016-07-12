package kalen.webapp.ustb_cc_website.dao;

import java.util.List;

import javax.annotation.Resource;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;

import kalen.webapp.ustb_cc_website.model.App;
import kalen.webapp.ustb_cc_website.model.MessageBoard;


@SuppressWarnings({ "unchecked", "deprecation" })
public class Dao {
	
	@Resource(name="sessionFactory")
	private SessionFactory sessionFactory;

	public void setSessionFactory(SessionFactory sessionFactory) {
		this.sessionFactory = sessionFactory;
	}

	public SessionFactory getSessionFactory() {
		return sessionFactory;
	}
	
	public List<App> getAllApps(){
		Session session = sessionFactory.getCurrentSession();
		return session.createQuery("from apps").list();
	}
	
	public List<MessageBoard> getAllComments(){
		Session session = sessionFactory.getCurrentSession();
		return session.createQuery("from message_boards").list();
	}
	
	public void insertComment(MessageBoard messageBoard) {
		System.out.println(messageBoard);
		Session session = sessionFactory.getCurrentSession();
		Transaction tx = session.beginTransaction();
		session.save(messageBoard);
		tx.commit();
	}


}
