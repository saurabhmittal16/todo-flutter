class ToDo {
    final int id;
    String title;
    bool done;

    ToDo({this.title, this.done, this.id});

    Map<String, dynamic> toMap() {
        return {
            'title': title,
            'done': done ? 1 : 0,
        };
    }

    void setTitle(String newTitle) {
        this.title = newTitle;
    }

    void toggleDone() {
        this.done = !this.done;
    }
}