package kalen.app.ustb_choose_course_system.model;

import java.io.Serializable;

/**
 * Created by kalen on 15-8-11.
 */
public class ClassBean implements Serializable{
    private String id = "";
    private String className = "";
    private String teacher = "";
    private int where = 0;
    private String time = "";
    private String position = "";
    private String time_and_postion = "";
    private String credit = "";
    private String score = "";
    private String kch = "";
    private String ratio = "";
    private String KXH = "";
    private String DYKCH = "";



    public ClassBean(String className, String score, String kch){
        this.className = className;
        this.score = score;
        this.kch = kch;
    }

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

    @Override
    public String toString() {
        return "ClassBean{" +
                "id='" + id + '\'' +
                ", className='" + className + '\'' +
                ", teacher='" + teacher + '\'' +
                ", where=" + where +
                ", time='" + time + '\'' +
                ", position='" + position + '\'' +
                ", time_and_postion='" + time_and_postion + '\'' +
                ", credit='" + credit + '\'' +
                ", score='" + score + '\'' +
                ", kch='" + kch + '\'' +
                '}';
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
                     String time_and_postion, String credit,
                     String ratio, String KXH, String DYKCH) {
        this.id = id;
        this.className = className;
        this.teacher = teacher;
        this.time_and_postion = time_and_postion;
        this.credit = credit;
        this.ratio = ratio;
        this.KXH = KXH;
        this.DYKCH = DYKCH;
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

    public String getKch() {
        return kch;
    }

    public void setKch(String kch) {
        this.kch = kch;
    }


    public String getDYKCH() {
        return DYKCH;
    }

    public void setDYKCH(String DYKCH) {
        this.DYKCH = DYKCH;
    }

    public String getKXH() {
        return KXH;
    }

    public void setKXH(String KXH) {
        this.KXH = KXH;
    }

    public String getRatio() {
        return ratio;
    }

    public void setRatio(String ratio) {
        this.ratio = ratio;
    }
}
