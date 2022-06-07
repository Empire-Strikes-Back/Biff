(ns Biff.ui-main
  (:require
   [clojure.core.async :as a
    :refer [chan put! take! close! offer! to-chan! timeout
            sliding-buffer dropping-buffer
            go >! <! alt! alts! do-alts
            mult tap untap pub sub unsub mix unmix admix
            pipe pipeline pipeline-async]]
   [clojure.string]
   [clojure.pprint]
   [cljs.core.async.impl.protocols :refer [closed?]]
   [cljs.core.async.interop :refer-macros [<p!]]
   [goog.string.format]
   [goog.string :refer [format]]
   [goog.object]
   [cljs.reader :refer [read-string]]
   [goog.events]

   ["react" :as react]
   ["react-dom/client" :as react-dom.client]

   [reagent.core]
   [reagent.dom]

   ["antd/lib/layout" :default AntdLayout]
   ["antd/lib/menu" :default AntdMenu]
   ["antd/lib/button" :default AntdButton]
   ["antd/lib/row" :default AntdRow]
   ["antd/lib/col" :default AntdCol]
   ["antd/lib/input" :default AntdInput]
   ["antd/lib/table" :default AntdTable]
   ["antd/lib/tabs" :default AntdTabs]
   ["antd/lib/space" :default AntdSpace]

   ["konva/lib/shapes/Rect"]
   ["konva" :default Konva]
   ["react-konva" :as ReactKonva :rename {Stage KonvaStage
                                          Layer KonvaLayer
                                          Rect KonvaRect
                                          Path KonvaPath
                                          Circle KonvaCircle
                                          Group KonvaGroup
                                          Wedge KonvaWedge
                                          RegularPolygon KonvaRegularPolygon}]

   ["@react-spring/web" :as ReactSpring :rename {animated ReactSpringAnimated
                                                 Spring ReactSpringSpring}]

   [Biff.ui-seed :refer [root]]))

(defn rc-ui
  []
  (reagent.core/with-let
    [dataA (reagent.core/cursor (:stateA root) [:simple-double-full])]
    [:> (.-Content AntdLayout)
     {:style {:background-color "white"}}
     [:<>
      [:div {}
       [:div "who's gonna pay my cleaning bill?"]]
      [:> AntdRow
       [:> AntdTable
        {:size "small"
         :style {:width "100%"
                 :height "80%"}
         :rowKey :git-url
         :columns [{:title "git-url"
                    :dataIndex "git-url"
                    :key "git-url"}
                   {:title "perform"
                    :dataIndex "perform"
                    :key "perform"
                    :render (fn [_ record]
                              ^{:key (aget record "name")}
                              (reagent.core/as-element
                               [:> AntdSpace
                                {}
                                [:> AntdButton "install"]
                                [:> AntdButton "run"]
                                [:> AntdButton "update"]
                                [:> AntdButton "uninstall"]]))}]
         :dataSource [{:git-url "https://github.com/move-me-to-ipfs-shipyard/Cara-Dune"}
                      {:git-url "https://github.com/move-me-to-ipfs-shipyard/Tyrion"}
                      {:git-url "https://github.com/move-me-to-ipfs-shipyard/Dr-Pershing"}
                      {:git-url "https://github.com/move-me-to-ipfs-shipyard/Beck"}
                      {:git-url "https://github.com/move-me-to-ipfs-shipyard/Vanth"}
                      {:git-url "https://github.com/move-me-to-ipfs-shipyard/Karga"}
                      {:git-url "https://github.com/move-me-to-ipfs-shipyard/Calican"}
                      {:git-url "https://github.com/move-me-to-ipfs-shipyardFennec"}
                      {:git-url "https://github.com/move-me-to-ipfs-shipyard/Elsbeth"}]}]]]]))

(defmulti op :op)

(defmethod op :ping
  [value]
  (go
    (clojure.pprint/pprint value)
    (put! (:program-send| root) {:op :pong
                                 :from :ui
                                 :moneybuster :Jesus})))

(defmethod op :pong
  [value]
  (go
    (clojure.pprint/pprint value)))

(defn ops-process
  [{:keys []
    :as opts}]
  (go
    (loop []
      (when-let [value (<! (:ops| root))]
        (<! (op value))
        (recur)))))

(defn -main
  []
  (go
    #_(<! (timeout 1000))
    (println "twelve is the new twony")
    (println ":Madison you though i was a zombie?")
    (println ":Columbus yeah, of course - a zombie")
    (println ":Madison oh my God, no - i dont even eat meat - i'm a vegatarian - vegan actually")
    #_(set! (.-innerHTML (.getElementById js/document "ui"))
            ":Co-Pilot i saw your planet destroyed - i was on the Death Star :_ which one?")
    (ops-process {})
    (.render @(:dom-rootA root) (reagent.core/as-element [rc-ui]))
    #_(websocket-process {:send| (:program-send| root)
                        :recv| (:ops| root)})))

(defn reload
  []
  (when-let [dom-root @(:dom-rootA root)]
    (.unmount dom-root)
    (let [new-dom-root (react-dom.client/createRoot (.getElementById js/document "ui"))]
      (reset! (:dom-rootA root) new-dom-root)
      (.render @(:dom-rootA root) (reagent.core/as-element [rc-ui])))))

#_(-main)