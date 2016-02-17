package kalen.app.ustb_choose_course_system.model;

/**
 * Created by kalen on 15-12-22.
 */
public class ExamInfo {
    private String className;
    private String examTime;
    private String examLocation;

    public ExamInfo(String className, String examTime, String examLocation) {
        this.className = className;
        this.examTime = examTime;
        this.examLocation = examLocation;
    }

    public String getClassName() {
        return className;
    }

    public void setClassName(String className) {
        this.className = className;
    }

    public String getExamTime() {
        return examTime;
    }

    public void setExamTime(String examTime) {
        this.examTime = examTime;
    }

    public String getExamLocation() {
        return examLocation;
    }

    public void setExamLocation(String examLocation) {
        this.examLocation = examLocation;
    }
}
