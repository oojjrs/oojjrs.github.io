---
layout: page
lang: en
title: "Otherwise"
description: "The ability to handle what lies outside normal operation and keep unknown failures discoverable."
permalink: /en/essays/otherwise/
alternate_url: /kr/essays/otherwise/
---

[← All notes]({{ "/en/" | relative_url }})
{: .article-backlink }

Implementing normal behavior is a developer's baseline. A feature is not finished merely because it works when the expected conditions hold; the developer must also decide what happens when those conditions do not hold.
{: .article-lead }

Programming languages usually express the opposite branch of a condition with `else`, but `otherwise` in this essay is broader than a syntactic `else`. At the logic level, most responses are not difficult: cancel an action when there is no target, or reject a purchase when the player lacks enough currency. Doing nothing can also be an intentional result. However, returning `false` or `null`, or exiting early, does not by itself mean that the situation was handled. If the meaning of the result and the caller's next action are undefined, the code has merely pushed the decision elsewhere.

This work is difficult because most human experience converges on normal behavior. People experience normal operation in much the same way, while failures take different forms depending on environment and timing. One developer encounters file permissions or locks; another encounters memory pressure or corrupted data. Even a network timeout can mean either that the request never arrived or that the server completed the work but the response never returned. They look like the same timeout, but retrying the former can be safe while retrying the latter can duplicate the operation. Experience broadens the range of failures a developer can anticipate, but no one can know every possible failure in advance.

Handling `otherwise` completely therefore cannot mean predicting and recovering from every failure. Known failures need concrete actions such as cancellation, retry, recovery, or termination. Unknown failures should not be converted into normal results or meaningless return values. When necessary, execution should stop safely; at minimum, the failure must be made discoverable. Notification is more than leaving a single error message. It must reach someone responsible and preserve the operation being performed, the input state, and any changes that have already occurred. A properly captured failure turns one person's accidental encounter into experience the team can share and later reflect in the system's handling.

Normal behavior must work well. What distinguishes developers beyond that is how many cases outside normal operation they know, whether known cases are handled properly, and whether unknown cases are noticed when they occur. A good developer is not someone who knows every failure in advance. A good developer expands the range they can handle through experience while ensuring that failures they do not yet know never disappear silently.
