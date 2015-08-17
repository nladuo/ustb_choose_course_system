package kalen.app.ustb_choose_course_system.model;

/**
 * Created by kalen on 15-8-11.
 */
public class ClassBean {
    private String id = "";
    private String className = "";
    private String teacher = "";
    private int where = 0;
    private String time = "";
    private String position = "";
    private String time_and_postion = "";
    private String credit = "";
    private String score = "";

    /**
     * for class table
     * @param className
     * @param teacher
     * @param where
     * @param time
     * @param position
     */
    public ClassBean(String className, String teacher, int where, String time, String position) {
        this.className = className;
        this.teacher = teacher;
        this.where = where;
        this.time = time;
        this.position = position;
    }

    /**
     * for learned course
     * @param className
     * @param teacher
     * @param credit
     * @param score
     */
    public ClassBean(String className, String teacher, String credit, String score) {
        this.className = className;
        this.teacher = teacher;
        this.credit = credit;
        this.score = score;
    }

    /**
     * for choose course
     * @param id
     * @param className
     * @param teacher
     * @param time_and_postion
     * @param credit
     */
    public ClassBean(String id, String className, String teacher,
                     String time_and_postion, String credit) {
        this.id = id;
        this.className = className;
        this.teacher = teacher;
        this.time_and_postion = time_and_postion;
        this.credit = credit;
    }

    public String getClassName() {
        return className;
    }

    public void setClassName(String className) {
        this.className = className;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTeacher() {
        return teacher;
    }

    public void setTeacher(String teacher) {
        this.teacher = teacher;
    }

    public int getWhere() {
        return where;
    }

    public void setWhere(int _where) {
        this.where = _where;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    public String getTime_and_postion() {
        return time_and_postion;
    }

    public void setTime_and_postion(String time_and_postion) {
        this.time_and_postion = time_and_postion;
    }

    public String getCredit() {
        return credit;
    }

    public void setCredit(String credit) {
        this.credit = credit;
    }

    public String getScore() {
        return score;
    }

    public void setScore(String score) {
        this.score = score;
    }
}
