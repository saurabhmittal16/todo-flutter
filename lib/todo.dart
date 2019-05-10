class ToDo {
    final int id;
    final String title;
    final bool done;

    ToDo({this.title, this.done, this.id});

    Map<String, dynamic> toMap() {
        return {
            'title': title,
            'done': done ? 1 : 0,
        };
    }
}